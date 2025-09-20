import 'dart:async';
import 'dart:math';
import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';

/// Background service for batch storage and data optimization
class BatchStorageService {
  final SampleRepository _sampleRepository;
  final SessionRepository _sessionRepository;
  final Duration _optimizationInterval;

  Timer? _optimizationTimer;
  bool _isOptimizing = false;
  final StreamController<OptimizationStatus> _statusController =
      StreamController<OptimizationStatus>.broadcast();

  BatchStorageService(
    this._sampleRepository,
    this._sessionRepository, {
    Duration optimizationInterval = const Duration(hours: 6),
  }) : _optimizationInterval = optimizationInterval {
    _startPeriodicOptimization();
  }

  /// Stream of optimization status updates
  Stream<OptimizationStatus> get statusStream => _statusController.stream;

  /// Convert individual ECG samples to batched storage for a session
  Future<void> optimizeEcgStorage(String sessionId) async {
    if (_isOptimizing) return;

    _isOptimizing = true;
    _updateStatus(sessionId, OptimizationPhase.preparingEcgBatching);

    try {
      // Get ECG samples in chunks
      const chunkSize = 10000;
      var offset = 0;
      var batchNumber = 0;

      while (true) {
        final samples = await _sampleRepository.getEcgSamples(
          sessionId,
          limit: chunkSize,
          offset: offset,
        );

        if (samples.isEmpty) break;

        // Create batch from samples
        final batch = _createEcgBatch(samples, batchNumber);
        await _sampleRepository.saveEcgBatch(batch);

        // Remove individual samples that are now batched
        // (This would be implemented based on specific database capabilities)

        offset += chunkSize;
        batchNumber++;

        _updateStatus(
          sessionId,
          OptimizationPhase.processingEcgBatches,
          progress: batchNumber,
        );
      }

      _updateStatus(sessionId, OptimizationPhase.completed);
    } catch (e) {
      _updateStatus(sessionId, OptimizationPhase.error, error: e.toString());
    } finally {
      _isOptimizing = false;
    }
  }

  /// Optimize storage for all sessions that haven't been optimized recently
  Future<void> optimizeAllSessions() async {
    if (_isOptimizing) return;

    _isOptimizing = true;

    try {
      final sessions = await _sessionRepository.getSessions();
      final completedSessions = sessions
          .where((session) => session.status == SessionStatus.completed)
          .toList();

      for (int i = 0; i < completedSessions.length; i++) {
        final session = completedSessions[i];

        _updateStatus(
          session.sessionId,
          OptimizationPhase.optimizingSession,
          progress: i + 1,
          total: completedSessions.length,
        );

        await _sampleRepository.optimizeSessionData(session.sessionId);

        // Add delay to prevent overwhelming the system
        await Future.delayed(const Duration(milliseconds: 100));
      }

      _updateStatus('all', OptimizationPhase.completed);
    } catch (e) {
      _updateStatus('all', OptimizationPhase.error, error: e.toString());
    } finally {
      _isOptimizing = false;
    }
  }

  /// Clean up old data based on retention policies
  Future<void> cleanupOldData({
    Duration? sessionRetention,
    Duration? sampleRetention,
  }) async {
    if (_isOptimizing) return;

    _isOptimizing = true;
    _updateStatus('cleanup', OptimizationPhase.cleanup);

    try {
      final now = DateTime.now();

      if (sessionRetention != null) {
        final cutoffDate = now.subtract(sessionRetention);
        final oldSessions = await _sessionRepository.getSessionsFiltered(
          endDate: cutoffDate,
          status: SessionStatus.completed,
        );

        for (final session in oldSessions) {
          await _sessionRepository.deleteSession(session.sessionId);
        }

        _updateStatus(
          'cleanup',
          OptimizationPhase.cleanupCompleted,
          progress: oldSessions.length,
        );
      }

      _updateStatus('cleanup', OptimizationPhase.completed);
    } catch (e) {
      _updateStatus('cleanup', OptimizationPhase.error, error: e.toString());
    } finally {
      _isOptimizing = false;
    }
  }

  /// Get storage statistics
  Future<StorageOptimizationStats> getStorageStats() async {
    final storageStats = await _sampleRepository.getStorageStatistics();

    return StorageOptimizationStats(
      totalSessions: storageStats.totalSessions,
      totalEcgSamples: storageStats.totalEcgSamples,
      totalHeartRateSamples: storageStats.totalHeartRateSamples,
      totalHrvSamples: storageStats.totalHrvSamples,
      databaseSizeMB: storageStats.databaseSizeMB,
      lastOptimized: storageStats.lastOptimized,
      isOptimizing: _isOptimizing,
    );
  }

  EcgSampleBatch _createEcgBatch(List<EcgSample> samples, int batchNumber) {
    if (samples.isEmpty) {
      throw ArgumentError('Cannot create batch from empty samples list');
    }

    samples.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final voltages = samples.map((s) => s.voltage).toList();
    final rPeakIndices = <int>[];

    for (int i = 0; i < samples.length; i++) {
      if (samples[i].isRPeak) {
        rPeakIndices.add(i);
      }
    }

    // Calculate sampling rate
    double samplingRate = 130.0; // Default Polar H10 rate
    if (samples.length > 1) {
      final totalDuration =
          samples.last.timestamp
              .difference(samples.first.timestamp)
              .inMilliseconds /
          1000.0;
      samplingRate = samples.length / totalDuration;
    }

    // Calculate quality metrics
    final avgQuality =
        samples
            .where((s) => s.quality != null)
            .map((s) => s.quality!)
            .fold(0, (a, b) => a + b) ~/
        max(1, samples.where((s) => s.quality != null).length);

    final quality = BatchQuality(
      averageQuality: avgQuality,
      artifactCount: 0, // Would be calculated based on signal analysis
      snr: null, // Would be calculated based on signal analysis
      baselineWander: null,
    );

    return EcgSampleBatch(
      sessionId: samples.first.sessionId,
      startTimestamp: samples.first.timestamp,
      endTimestamp: samples.last.timestamp,
      samplingRate: samplingRate,
      voltages: voltages,
      rPeakIndices: rPeakIndices,
      batchNumber: batchNumber,
      quality: quality,
    );
  }

  void _startPeriodicOptimization() {
    _optimizationTimer = Timer.periodic(_optimizationInterval, (_) {
      optimizeAllSessions();
    });
  }

  void _updateStatus(
    String sessionId,
    OptimizationPhase phase, {
    int? progress,
    int? total,
    String? error,
  }) {
    _statusController.add(
      OptimizationStatus(
        sessionId: sessionId,
        phase: phase,
        progress: progress,
        total: total,
        error: error,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Dispose resources
  void dispose() {
    _optimizationTimer?.cancel();
    _statusController.close();
  }
}

/// Optimization status information
class OptimizationStatus {
  final String sessionId;
  final OptimizationPhase phase;
  final int? progress;
  final int? total;
  final String? error;
  final DateTime timestamp;

  const OptimizationStatus({
    required this.sessionId,
    required this.phase,
    this.progress,
    this.total,
    this.error,
    required this.timestamp,
  });

  double? get progressPercentage {
    if (progress == null || total == null || total == 0) return null;
    return progress! / total!;
  }

  bool get isError => phase == OptimizationPhase.error;
  bool get isCompleted => phase == OptimizationPhase.completed;

  @override
  String toString() {
    return 'OptimizationStatus{session: $sessionId, phase: $phase, progress: $progress/$total}';
  }
}

/// Optimization phases
enum OptimizationPhase {
  preparingEcgBatching,
  processingEcgBatches,
  optimizingSession,
  cleanup,
  cleanupCompleted,
  completed,
  error,
}

/// Storage optimization statistics
class StorageOptimizationStats {
  final int totalSessions;
  final int totalEcgSamples;
  final int totalHeartRateSamples;
  final int totalHrvSamples;
  final double databaseSizeMB;
  final DateTime lastOptimized;
  final bool isOptimizing;

  const StorageOptimizationStats({
    required this.totalSessions,
    required this.totalEcgSamples,
    required this.totalHeartRateSamples,
    required this.totalHrvSamples,
    required this.databaseSizeMB,
    required this.lastOptimized,
    required this.isOptimizing,
  });

  int get totalSamples =>
      totalEcgSamples + totalHeartRateSamples + totalHrvSamples;

  double get averageSamplesPerSession =>
      totalSessions > 0 ? totalSamples / totalSessions : 0;

  @override
  String toString() {
    return 'StorageOptimizationStats{sessions: $totalSessions, samples: $totalSamples, size: ${databaseSizeMB}MB}';
  }
}

/// Riverpod provider for batch storage service
// Providers are defined in `lib/src/providers/data_providers.dart`
