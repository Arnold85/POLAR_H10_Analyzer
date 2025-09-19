import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import 'csv_export_service.dart';

/// Service for exporting ECG data to EDF (European Data Format) files
/// EDF is the standard format for storing physiological signals
class EdfExportService {
  final SessionRepository _sessionRepository;
  final SampleRepository _sampleRepository;

  const EdfExportService(
    this._sessionRepository,
    this._sampleRepository,
  );

  /// Export session ECG data to EDF format
  Future<ExportResult> exportSession(
    String sessionId, {
    EdfExportOptions? options,
  }) async {
    try {
      final session = await _sessionRepository.getSession(sessionId);
      if (session == null) {
        throw ExportException('Session not found: $sessionId');
      }

      final exportOptions = options ?? const EdfExportOptions();
      final exportDir = await _createExportDirectory(sessionId);
      
      // Get ECG data
      final ecgSamples = await _sampleRepository.getEcgSamples(
        sessionId,
        startTime: exportOptions.startTime,
        endTime: exportOptions.endTime,
      );

      if (ecgSamples.isEmpty) {
        throw ExportException('No ECG data found for session');
      }

      final edfFile = await _createEdfFile(
        session,
        ecgSamples,
        exportDir,
        exportOptions,
      );

      return ExportResult(
        success: true,
        exportPath: edfFile,
        files: [edfFile],
        format: ExportFormat.edf,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        errorMessage: e.toString(),
        format: ExportFormat.edf,
      );
    }
  }

  Future<Directory> _createExportDirectory(String sessionId) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(
      documentsDir.path,
      'exports',
      'edf',
    ));
    
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    
    return exportDir;
  }

  Future<String> _createEdfFile(
    MeasurementSession session,
    List<EcgSample> ecgSamples,
    Directory exportDir,
    EdfExportOptions options,
  ) async {
    final fileName = 'session_${session.sessionId}_${DateTime.now().millisecondsSinceEpoch}.edf';
    final file = File(p.join(exportDir.path, fileName));

    // Calculate sampling rate
    final samplingRate = _calculateSamplingRate(ecgSamples);
    
    // Create EDF header
    final header = _createEdfHeader(
      session,
      ecgSamples,
      samplingRate,
      options,
    );

    // Create data records
    final dataRecords = _createDataRecords(ecgSamples, samplingRate, options);

    // Write EDF file
    final fileData = BytesBuilder();
    fileData.add(header);
    fileData.add(dataRecords);

    await file.writeAsBytes(fileData.toBytes());
    return file.path;
  }

  double _calculateSamplingRate(List<EcgSample> samples) {
    if (samples.length < 2) return 130.0; // Default Polar H10 rate

    // Calculate average time difference between samples
    var totalDiff = 0;
    for (int i = 1; i < samples.length && i < 1000; i++) {
      totalDiff += samples[i].timestamp.difference(samples[i-1].timestamp).inMicroseconds;
    }
    
    final avgDiffMicros = totalDiff / (samples.length - 1).clamp(1, 999);
    return 1000000.0 / avgDiffMicros; // Convert to Hz
  }

  Uint8List _createEdfHeader(
    MeasurementSession session,
    List<EcgSample> samples,
    double samplingRate,
    EdfExportOptions options,
  ) {
    final header = BytesBuilder();

    // EDF header is exactly 256 bytes for header + (256 * number of signals) bytes
    final numSignals = 1; // ECG signal
    final headerSize = 256 + (256 * numSignals);

    // Fixed header (256 bytes)
    header.add(_padString('0       ', 8)); // Version (8)
    header.add(_padString('Polar H10 ${session.deviceId}', 80)); // Patient info (80)
    header.add(_padString('Session ${session.sessionId}', 80)); // Recording info (80)
    header.add(_padString(session.startTime.toIso8601String().substring(0, 16).replaceAll('-', '.').replaceAll('T', '.'), 8)); // Start date (8)
    header.add(_padString(session.startTime.toIso8601String().substring(11, 19).replaceAll(':', '.'), 8)); // Start time (8)
    header.add(_padString(headerSize.toString(), 8)); // Header bytes (8)
    header.add(_padString('EDF+C   ', 44)); // Reserved (44)
    
    // Calculate number of data records and duration
    final durationSeconds = samples.isNotEmpty 
        ? samples.last.timestamp.difference(samples.first.timestamp).inSeconds
        : 0;
    final numRecords = (durationSeconds / options.recordDurationSeconds).ceil();
    
    header.add(_padString(numRecords.toString(), 8)); // Number of records (8)
    header.add(_padString(options.recordDurationSeconds.toString(), 8)); // Duration of record (8)
    header.add(_padString(numSignals.toString(), 4)); // Number of signals (4)

    // Signal-specific headers (256 bytes per signal)
    // Label (16)
    header.add(_padString('ECG', 16));
    
    // Transducer type (80)
    header.add(_padString('Polar H10 Chest Strap', 80));
    
    // Physical dimension (8)
    header.add(_padString('mV', 8));
    
    // Physical minimum (8)
    header.add(_padString(options.physicalMin.toString(), 8));
    
    // Physical maximum (8)
    header.add(_padString(options.physicalMax.toString(), 8));
    
    // Digital minimum (8)
    header.add(_padString(options.digitalMin.toString(), 8));
    
    // Digital maximum (8)
    header.add(_padString(options.digitalMax.toString(), 8));
    
    // Prefiltering (80)
    header.add(_padString('HP:0.5Hz LP:40Hz', 80));
    
    // Samples per record (8)
    final samplesPerRecord = (samplingRate * options.recordDurationSeconds).round();
    header.add(_padString(samplesPerRecord.toString(), 8));
    
    // Reserved (32)
    header.add(_padString('', 32));

    return header.toBytes();
  }

  Uint8List _createDataRecords(
    List<EcgSample> samples,
    double samplingRate,
    EdfExportOptions options,
  ) {
    final records = BytesBuilder();
    final samplesPerRecord = (samplingRate * options.recordDurationSeconds).round();
    
    // Group samples into records
    for (int recordIndex = 0; recordIndex < samples.length; recordIndex += samplesPerRecord) {
      final recordSamples = samples.skip(recordIndex).take(samplesPerRecord).toList();
      
      // Pad record if necessary
      while (recordSamples.length < samplesPerRecord) {
        recordSamples.add(EcgSample(
          sessionId: samples.first.sessionId,
          timestamp: samples.last.timestamp,
          voltage: 0.0,
          sequenceNumber: samples.length + recordSamples.length,
        ));
      }
      
      // Convert voltage values to 16-bit integers
      for (final sample in recordSamples) {
        final digitalValue = _voltageToDigital(sample.voltage, options);
        records.add(_int16ToBytes(digitalValue));
      }
    }
    
    return records.toBytes();
  }

  int _voltageToDigital(double voltage, EdfExportOptions options) {
    // Scale voltage to digital range
    final range = options.physicalMax - options.physicalMin;
    final digitalRange = options.digitalMax - options.digitalMin;
    
    final normalizedVoltage = (voltage - options.physicalMin) / range;
    final digitalValue = (normalizedVoltage * digitalRange + options.digitalMin).round();
    
    return digitalValue.clamp(options.digitalMin, options.digitalMax);
  }

  Uint8List _int16ToBytes(int value) {
    final bytes = ByteData(2);
    bytes.setInt16(0, value, Endian.little);
    return bytes.buffer.asUint8List();
  }

  Uint8List _padString(String text, int length) {
    final padded = text.padRight(length).substring(0, length);
    return Uint8List.fromList(padded.codeUnits);
  }
}

/// EDF export configuration options
class EdfExportOptions {
  final DateTime? startTime;
  final DateTime? endTime;
  final double recordDurationSeconds;
  final double physicalMin;
  final double physicalMax;
  final int digitalMin;
  final int digitalMax;

  const EdfExportOptions({
    this.startTime,
    this.endTime,
    this.recordDurationSeconds = 1.0,
    this.physicalMin = -5.0, // mV
    this.physicalMax = 5.0,  // mV
    this.digitalMin = -32768,
    this.digitalMax = 32767,
  });
}