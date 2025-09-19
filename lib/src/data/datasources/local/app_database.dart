import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'database_tables.dart';

part 'app_database.g.dart';

/// Main application database using Drift
@DriftDatabase(tables: [
  PolarDevices,
  MeasurementSessions,
  EcgSamples,
  EcgSampleBatches,
  HeartRateSamples,
  HrvSamples,
  AnalysisResults,
  ExportHistory,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createIndexes();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Handle database migrations here when schema version changes
    },
  );

  /// Create database indexes for better query performance
  Future<void> _createIndexes() async {
    // Sessions indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sessions_device_id ON measurement_sessions(device_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sessions_start_time ON measurement_sessions(start_time)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_sessions_status ON measurement_sessions(status)',
    );

    // ECG samples indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_ecg_samples_session_id ON ecg_samples(session_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_ecg_samples_timestamp ON ecg_samples(timestamp)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_ecg_samples_r_peaks ON ecg_samples(session_id, is_r_peak) WHERE is_r_peak = 1',
    );

    // ECG batches indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_ecg_batches_session_id ON ecg_sample_batches(session_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_ecg_batches_timestamp ON ecg_sample_batches(start_timestamp)',
    );

    // Heart rate samples indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_hr_samples_session_id ON heart_rate_samples(session_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_hr_samples_timestamp ON heart_rate_samples(timestamp)',
    );

    // HRV samples indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_hrv_samples_session_id ON hrv_samples(session_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_hrv_samples_timestamp ON hrv_samples(timestamp)',
    );

    // Analysis results indexes
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_analysis_session_id ON analysis_results(session_id)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_analysis_type ON analysis_results(analysis_type)',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_analysis_timestamp ON analysis_results(analysis_timestamp)',
    );
  }

  /// Clean up old data based on retention policies
  Future<void> cleanupOldData({
    Duration? sessionRetention,
    Duration? sampleRetention,
  }) async {
    final now = DateTime.now();
    
    if (sessionRetention != null) {
      final cutoffDate = now.subtract(sessionRetention);
      
      // Delete old completed sessions and their data
  final oldSessions = await (select(measurementSessions)
    ..where((s) => s.endTime.isNotNull() & 
          s.endTime.isSmallerThanValue(cutoffDate) &
          s.status.equals('completed')))
      .get();
      
      for (final session in oldSessions) {
        await _deleteSessionData(session.sessionId);
      }
    }
    
    if (sampleRetention != null) {
      final cutoffDate = now.subtract(sampleRetention);
      
      // Archive old ECG samples to batches and delete individual samples
      await _archiveOldEcgSamples(cutoffDate);
    }
  }

  /// Delete all data for a session
  Future<void> _deleteSessionData(String sessionId) async {
    await transaction(() async {
      await (delete(ecgSamples)..where((s) => s.sessionId.equals(sessionId))).go();
      await (delete(ecgSampleBatches)..where((s) => s.sessionId.equals(sessionId))).go();
      await (delete(heartRateSamples)..where((s) => s.sessionId.equals(sessionId))).go();
      await (delete(hrvSamples)..where((s) => s.sessionId.equals(sessionId))).go();
      await (delete(analysisResults)..where((s) => s.sessionId.equals(sessionId))).go();
      await (delete(exportHistory)..where((s) => s.sessionId.equals(sessionId))).go();
      await (delete(measurementSessions)..where((s) => s.sessionId.equals(sessionId))).go();
    });
  }

  /// Archive old ECG samples to batch storage
  Future<void> _archiveOldEcgSamples(DateTime cutoffDate) async {
    // Implementation would batch old samples and delete originals
    // This is a complex operation that would be implemented based on specific requirements
  }

  /// Get database size statistics
  Future<DatabaseStats> getDatabaseStats() async {
    final result = await customSelect(
      '''
      SELECT 
        (SELECT COUNT(*) FROM measurement_sessions) as session_count,
        (SELECT COUNT(*) FROM ecg_samples) as ecg_sample_count,
        (SELECT COUNT(*) FROM ecg_sample_batches) as ecg_batch_count,
        (SELECT COUNT(*) FROM heart_rate_samples) as hr_sample_count,
        (SELECT COUNT(*) FROM hrv_samples) as hrv_sample_count,
        (SELECT COUNT(*) FROM analysis_results) as analysis_count
      ''',
    ).getSingle();

    return DatabaseStats(
      sessionCount: result.read<int>('session_count'),
      ecgSampleCount: result.read<int>('ecg_sample_count'),
      ecgBatchCount: result.read<int>('ecg_batch_count'),
      hrSampleCount: result.read<int>('hr_sample_count'),
      hrvSampleCount: result.read<int>('hrv_sample_count'),
      analysisCount: result.read<int>('analysis_count'),
    );
  }
}

/// Database connection setup
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'polar_h10_analyzer.db'));
    return NativeDatabase.createInBackground(file);
  });
}

/// Database statistics
class DatabaseStats {
  final int sessionCount;
  final int ecgSampleCount;
  final int ecgBatchCount;
  final int hrSampleCount;
  final int hrvSampleCount;
  final int analysisCount;

  const DatabaseStats({
    required this.sessionCount,
    required this.ecgSampleCount,
    required this.ecgBatchCount,
    required this.hrSampleCount,
    required this.hrvSampleCount,
    required this.analysisCount,
  });

  double get totalSampleCount => 
      (ecgSampleCount + hrSampleCount + hrvSampleCount).toDouble();

  @override
  String toString() {
    return 'DatabaseStats{sessions: $sessionCount, ecgSamples: $ecgSampleCount, hrSamples: $hrSampleCount, analyses: $analysisCount}';
  }
}