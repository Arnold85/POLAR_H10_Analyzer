import 'dart:async';
import 'dart:collection';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show debugPrint;

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import '../../providers/data_providers.dart';

/// Background service for buffering and batch processing streaming data
class DataBufferingService {
  final SampleRepository _sampleRepository;
  final int _maxBufferSize;
  final Duration _flushInterval;

  // Data buffers
  final Queue<EcgSample> _ecgBuffer = Queue<EcgSample>();
  final Queue<HeartRateSample> _hrBuffer = Queue<HeartRateSample>();
  final Queue<HrvSample> _hrvBuffer = Queue<HrvSample>();

  Timer? _flushTimer;
  bool _isProcessing = false;
  final StreamController<BufferStatus> _statusController =
      StreamController<BufferStatus>.broadcast();

  DataBufferingService(
    this._sampleRepository, {
    int maxBufferSize = 1000,
    Duration flushInterval = const Duration(seconds: 30),
  }) : _maxBufferSize = maxBufferSize,
       _flushInterval = flushInterval {
    _startPeriodicFlush();
  }

  /// Stream of buffer status updates
  Stream<BufferStatus> get statusStream => _statusController.stream;

  /// Add ECG sample to buffer
  void addEcgSample(EcgSample sample) {
    _ecgBuffer.add(sample);

    if (_ecgBuffer.length >= _maxBufferSize) {
      _flushEcgBuffer();
    }

    _updateStatus();
  }

  /// Add heart rate sample to buffer
  void addHeartRateSample(HeartRateSample sample) {
    _hrBuffer.add(sample);

    if (_hrBuffer.length >= _maxBufferSize) {
      _flushHeartRateBuffer();
    }

    _updateStatus();
  }

  /// Add HRV sample to buffer
  void addHrvSample(HrvSample sample) {
    _hrvBuffer.add(sample);

    if (_hrvBuffer.length >= _maxBufferSize) {
      _flushHrvBuffer();
    }

    _updateStatus();
  }

  /// Add multiple ECG samples at once
  void addEcgSamples(List<EcgSample> samples) {
    _ecgBuffer.addAll(samples);

    if (_ecgBuffer.length >= _maxBufferSize) {
      _flushEcgBuffer();
    }

    _updateStatus();
  }

  /// Add ECG batch directly (for bulk streaming data)
  Future<void> addEcgBatch(EcgSampleBatch batch) async {
    try {
      await _sampleRepository.saveEcgBatch(batch);
    } catch (e) {
      // Log error and potentially retry
      // Use debugPrint instead of print to respect lint rules
      debugPrint('Error saving ECG batch: $e');
    }
  }

  /// Force flush all buffers
  Future<void> flushAll() async {
    if (_isProcessing) return;

    _isProcessing = true;
    _updateStatus();

    try {
      await Future.wait([
        _flushEcgBuffer(),
        _flushHeartRateBuffer(),
        _flushHrvBuffer(),
      ]);
    } finally {
      _isProcessing = false;
      _updateStatus();
    }
  }

  /// Get current buffer status
  BufferStatus getStatus() {
    return BufferStatus(
      ecgBufferSize: _ecgBuffer.length,
      hrBufferSize: _hrBuffer.length,
      hrvBufferSize: _hrvBuffer.length,
      isProcessing: _isProcessing,
      maxBufferSize: _maxBufferSize,
    );
  }

  void _startPeriodicFlush() {
    _flushTimer = Timer.periodic(_flushInterval, (_) => flushAll());
  }

  Future<void> _flushEcgBuffer() async {
    if (_ecgBuffer.isEmpty) return;

    final samples = <EcgSample>[];
    while (_ecgBuffer.isNotEmpty && samples.length < _maxBufferSize) {
      samples.add(_ecgBuffer.removeFirst());
    }

    try {
      await _sampleRepository.saveEcgSamples(samples);
    } catch (e) {
      // Re-add samples to front of buffer for retry
      for (int i = samples.length - 1; i >= 0; i--) {
        _ecgBuffer.addFirst(samples[i]);
      }
      rethrow;
    }
  }

  Future<void> _flushHeartRateBuffer() async {
    if (_hrBuffer.isEmpty) return;

    final samples = <HeartRateSample>[];
    while (_hrBuffer.isNotEmpty && samples.length < _maxBufferSize) {
      samples.add(_hrBuffer.removeFirst());
    }

    try {
      await _sampleRepository.saveHeartRateSamples(samples);
    } catch (e) {
      // Re-add samples to front of buffer for retry
      for (int i = samples.length - 1; i >= 0; i--) {
        _hrBuffer.addFirst(samples[i]);
      }
      rethrow;
    }
  }

  Future<void> _flushHrvBuffer() async {
    if (_hrvBuffer.isEmpty) return;

    final samples = <HrvSample>[];
    while (_hrvBuffer.isNotEmpty && samples.length < _maxBufferSize) {
      samples.add(_hrvBuffer.removeFirst());
    }

    try {
      await _sampleRepository.saveHrvSamples(samples);
    } catch (e) {
      // Re-add samples to front of buffer for retry
      for (int i = samples.length - 1; i >= 0; i--) {
        _hrvBuffer.addFirst(samples[i]);
      }
      rethrow;
    }
  }

  void _updateStatus() {
    _statusController.add(getStatus());
  }

  /// Dispose resources
  void dispose() {
    _flushTimer?.cancel();
    _statusController.close();
    flushAll(); // Final flush
  }
}

/// Buffer status information
class BufferStatus {
  final int ecgBufferSize;
  final int hrBufferSize;
  final int hrvBufferSize;
  final bool isProcessing;
  final int maxBufferSize;

  const BufferStatus({
    required this.ecgBufferSize,
    required this.hrBufferSize,
    required this.hrvBufferSize,
    required this.isProcessing,
    required this.maxBufferSize,
  });

  int get totalBufferedSamples => ecgBufferSize + hrBufferSize + hrvBufferSize;

  double get bufferUtilization => totalBufferedSamples / (maxBufferSize * 3);

  bool get isNearCapacity => bufferUtilization > 0.8;

  @override
  String toString() {
    return 'BufferStatus{ECG: $ecgBufferSize, HR: $hrBufferSize, HRV: $hrvBufferSize, processing: $isProcessing}';
  }
}

/// Riverpod provider for data buffering service
final dataBufferingServiceProvider = Provider<DataBufferingService>((ref) {
  final sampleRepository = ref.watch(sampleRepositoryProvider);
  return DataBufferingService(sampleRepository);
});
