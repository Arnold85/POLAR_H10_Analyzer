import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';

/// Service for exporting session data to CSV format
class CsvExportService {
  final SessionRepository _sessionRepository;
  final SampleRepository _sampleRepository;
  final AnalysisRepository _analysisRepository;

  const CsvExportService(
    this._sessionRepository,
    this._sampleRepository,
    this._analysisRepository,
  );

  /// Export complete session data to CSV files
  Future<ExportResult> exportSession(
    String sessionId, {
    ExportOptions? options,
  }) async {
    try {
      final session = await _sessionRepository.getSession(sessionId);
      if (session == null) {
        throw ExportException('Session not found: $sessionId');
      }

      final exportOptions = options ?? const ExportOptions();
      final exportDir = await _createExportDirectory(sessionId);
      final exportedFiles = <String>[];

      // Export session metadata
      if (exportOptions.includeSessionData) {
        final sessionFile = await _exportSessionMetadata(session, exportDir);
        exportedFiles.add(sessionFile);
      }

      // Export ECG data
      if (exportOptions.includeEcgData) {
        final ecgFile = await _exportEcgData(sessionId, exportDir, exportOptions);
        if (ecgFile != null) exportedFiles.add(ecgFile);
      }

      // Export heart rate data
      if (exportOptions.includeHeartRateData) {
        final hrFile = await _exportHeartRateData(sessionId, exportDir, exportOptions);
        if (hrFile != null) exportedFiles.add(hrFile);
      }

      // Export HRV data
      if (exportOptions.includeHrvData) {
        final hrvFile = await _exportHrvData(sessionId, exportDir, exportOptions);
        if (hrvFile != null) exportedFiles.add(hrvFile);
      }

      // Export analysis results
      if (exportOptions.includeAnalysisData) {
        final analysisFile = await _exportAnalysisData(sessionId, exportDir);
        if (analysisFile != null) exportedFiles.add(analysisFile);
      }

      return ExportResult(
        success: true,
        exportPath: exportDir.path,
        files: exportedFiles,
        format: ExportFormat.csv,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        errorMessage: e.toString(),
        format: ExportFormat.csv,
      );
    }
  }

  Future<Directory> _createExportDirectory(String sessionId) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(
      documentsDir.path,
      'exports',
      'csv',
      'session_$sessionId',
    ));
    
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    
    return exportDir;
  }

  Future<String> _exportSessionMetadata(MeasurementSession session, Directory exportDir) async {
    final file = File(p.join(exportDir.path, 'session_metadata.csv'));
    
    final headers = [
      'session_id',
      'device_id',
      'start_time',
      'end_time',
      'status',
      'type',
      'duration_seconds',
      'tags',
      'notes',
    ];

    final data = [
      session.sessionId,
      session.deviceId,
      session.startTime.toIso8601String(),
      session.endTime?.toIso8601String() ?? '',
      session.status.name,
      session.type.name,
      session.durationSeconds.toString(),
      session.tags.join(';'),
      session.notes ?? '',
    ];

    final csv = const ListToCsvConverter().convert([headers, data]);
    await file.writeAsString(csv);
    
    return file.path;
  }

  Future<String?> _exportEcgData(
    String sessionId,
    Directory exportDir,
    ExportOptions options,
  ) async {
    final ecgSamples = await _sampleRepository.getEcgSamples(
      sessionId,
      startTime: options.startTime,
      endTime: options.endTime,
      limit: options.maxSamples,
    );

    if (ecgSamples.isEmpty) return null;

    final file = File(p.join(exportDir.path, 'ecg_data.csv'));
    
    final headers = [
      'timestamp',
      'voltage_mv',
      'sequence_number',
      'quality',
      'is_r_peak',
      'lead_id',
    ];

    final rows = [headers];
    for (final sample in ecgSamples) {
      rows.add([
        sample.timestamp.toIso8601String(),
        sample.voltage.toString(),
        sample.sequenceNumber.toString(),
        sample.quality?.toString() ?? '',
        sample.isRPeak.toString(),
        sample.leadId ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
    
    return file.path;
  }

  Future<String?> _exportHeartRateData(
    String sessionId,
    Directory exportDir,
    ExportOptions options,
  ) async {
    final hrSamples = await _sampleRepository.getHeartRateSamples(
      sessionId,
      startTime: options.startTime,
      endTime: options.endTime,
      limit: options.maxSamples,
    );

    if (hrSamples.isEmpty) return null;

    final file = File(p.join(exportDir.path, 'heart_rate_data.csv'));
    
    final headers = [
      'timestamp',
      'heart_rate_bpm',
      'rr_intervals_ms',
      'contact_detected',
      'quality',
      'source',
    ];

    final rows = [headers];
    for (final sample in hrSamples) {
      rows.add([
        sample.timestamp.toIso8601String(),
        sample.heartRate.toString(),
        sample.rrIntervals.join(';'),
        sample.contactDetected.toString(),
        sample.quality?.toString() ?? '',
        sample.source.name,
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
    
    return file.path;
  }

  Future<String?> _exportHrvData(
    String sessionId,
    Directory exportDir,
    ExportOptions options,
  ) async {
    final hrvSamples = await _sampleRepository.getHrvSamples(
      sessionId,
      startTime: options.startTime,
      endTime: options.endTime,
      limit: options.maxSamples,
    );

    if (hrvSamples.isEmpty) return null;

    final file = File(p.join(exportDir.path, 'hrv_data.csv'));
    
    final headers = [
      'timestamp',
      'window_seconds',
      'rr_intervals_ms',
      'rmssd',
      'sdnn',
      'pnn50',
      'mean_rr',
      'heart_rate',
      'stress_index',
    ];

    final rows = [headers];
    for (final sample in hrvSamples) {
      rows.add([
        sample.timestamp.toIso8601String(),
        sample.windowSeconds.toString(),
        sample.rrIntervals.join(';'),
        sample.rmssd?.toString() ?? '',
        sample.sdnn?.toString() ?? '',
        sample.pnn50?.toString() ?? '',
        sample.meanRR?.toString() ?? '',
        sample.heartRate?.toString() ?? '',
        sample.stressIndex?.toString() ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
    
    return file.path;
  }

  Future<String?> _exportAnalysisData(String sessionId, Directory exportDir) async {
    final analysisResults = await _analysisRepository.getAnalysisResults(sessionId);
    
    if (analysisResults.isEmpty) return null;

    final file = File(p.join(exportDir.path, 'analysis_results.csv'));
    
    final headers = [
      'analysis_id',
      'analysis_type',
      'timestamp',
      'algorithm_version',
      'status',
      'confidence',
      'processing_time_ms',
      'data_json',
      'error_message',
    ];

    final rows = [headers];
    for (final result in analysisResults) {
      rows.add([
        result.analysisId,
        result.analysisType.name,
        result.analysisTimestamp.toIso8601String(),
        result.algorithmVersion,
        result.status.name,
        result.confidence?.toString() ?? '',
        result.processingTimeMs?.toString() ?? '',
        jsonEncode(result.data.toJson()),
        result.errorMessage ?? '',
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
    
    return file.path;
  }
}

/// Export configuration options
class ExportOptions {
  final bool includeSessionData;
  final bool includeEcgData;
  final bool includeHeartRateData;
  final bool includeHrvData;
  final bool includeAnalysisData;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? maxSamples;

  const ExportOptions({
    this.includeSessionData = true,
    this.includeEcgData = true,
    this.includeHeartRateData = true,
    this.includeHrvData = true,
    this.includeAnalysisData = true,
    this.startTime,
    this.endTime,
    this.maxSamples,
  });
}

/// Export result container
class ExportResult {
  final bool success;
  final String? exportPath;
  final List<String> files;
  final ExportFormat format;
  final String? errorMessage;

  const ExportResult({
    required this.success,
    this.exportPath,
    this.files = const [],
    required this.format,
    this.errorMessage,
  });
}

/// Export format enumeration
enum ExportFormat {
  csv,
  edf,
  pdf,
}

/// Export exception
class ExportException implements Exception {
  final String message;
  
  const ExportException(this.message);
  
  @override
  String toString() => 'ExportException: $message';
}