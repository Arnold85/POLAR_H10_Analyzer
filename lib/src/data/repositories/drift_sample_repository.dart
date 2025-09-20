import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/models/ecg_sample.dart';
import '../../domain/models/heart_rate_sample.dart';
import '../../domain/repositories/sample_repository.dart';
import '../datasources/local/app_database.dart' as db;
import '../models/data_mappers.dart';
import '../models/compression_utils.dart';

/// Concrete implementation of SampleRepository using Drift database
class DriftSampleRepository implements SampleRepository {
  final db.AppDatabase _database;

  const DriftSampleRepository(this._database);

  // ECG Sample operations

  @override
  Future<void> saveEcgSamples(List<EcgSample> samples) async {
    if (samples.isEmpty) return;

    await _database.batch((batch) {
      for (final sample in samples) {
        batch.insert(_database.ecgSamples, sample.toCompanion());
      }
    });
  }

  @override
  Future<void> saveEcgBatch(EcgSampleBatch batch) async {
    // Compress voltage data for efficient storage
    final voltageBytes = compressVoltageData(batch.voltages);
    final rPeakBytes = compressRPeakIndices(batch.rPeakIndices);

    final qualityJson = batch.quality != null
        ? jsonEncode(batch.quality!.toJson())
        : null;

    await _database
        .into(_database.ecgSampleBatches)
        .insertOnConflictUpdate(
          db.EcgSampleBatchesCompanion.insert(
            sessionId: batch.sessionId,
            startTimestamp: batch.startTimestamp,
            endTimestamp: batch.endTimestamp,
            samplingRate: batch.samplingRate,
            voltagesData: voltageBytes,
            rPeakIndices: Value(rPeakBytes),
            batchNumber: batch.batchNumber,
            sampleCount: batch.voltages.length,
            qualityMetrics: Value(qualityJson),
          ),
        );
  }

  @override
  Future<List<EcgSample>> getEcgSamples(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
    int? offset,
  }) async {
    final query = _database.select(_database.ecgSamples)
      ..where((sample) => sample.sessionId.equals(sessionId));

    if (startTime != null) {
      query.where((sample) => sample.timestamp.isBiggerOrEqualValue(startTime));
    }

    if (endTime != null) {
      query.where((sample) => sample.timestamp.isSmallerOrEqualValue(endTime));
    }

    query.orderBy([(sample) => OrderingTerm.asc(sample.sequenceNumber)]);

    if (offset != null) {
      query.limit(limit ?? 1000, offset: offset);
    } else if (limit != null) {
      query.limit(limit);
    }

    final entities = await query.get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<List<EcgSampleBatch>> getEcgBatches(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    final query = _database.select(_database.ecgSampleBatches)
      ..where((batch) => batch.sessionId.equals(sessionId));

    if (startTime != null) {
      query.where(
        (batch) => batch.startTimestamp.isBiggerOrEqualValue(startTime),
      );
    }

    if (endTime != null) {
      query.where((batch) => batch.endTimestamp.isSmallerOrEqualValue(endTime));
    }

    query.orderBy([(batch) => OrderingTerm.asc(batch.batchNumber)]);

    if (limit != null) {
      query.limit(limit);
    }

    final entities = await query.get();
    return entities.map((entity) => entity.toDomainBatch()).toList();
  }

  @override
  Future<int> getEcgSampleCount(String sessionId) async {
    final result =
        await (_database.selectOnly(_database.ecgSamples)
              ..addColumns([_database.ecgSamples.id.count()])
              ..where(_database.ecgSamples.sessionId.equals(sessionId)))
            .getSingle();
    return result.read(_database.ecgSamples.id.count()) ?? 0;
  }

  @override
  Future<void> deleteEcgSamples(String sessionId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.ecgSamples,
      )..where((sample) => sample.sessionId.equals(sessionId))).go();

      await (_database.delete(
        _database.ecgSampleBatches,
      )..where((batch) => batch.sessionId.equals(sessionId))).go();
    });
  }

  // Heart Rate Sample operations

  @override
  Future<void> saveHeartRateSamples(List<HeartRateSample> samples) async {
    if (samples.isEmpty) return;

    await _database.batch((batch) {
      for (final sample in samples) {
        batch.insert(_database.heartRateSamples, sample.toCompanion());
      }
    });
  }

  @override
  Future<List<HeartRateSample>> getHeartRateSamples(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
    int? offset,
  }) async {
    final query = _database.select(_database.heartRateSamples)
      ..where((sample) => sample.sessionId.equals(sessionId));

    if (startTime != null) {
      query.where((sample) => sample.timestamp.isBiggerOrEqualValue(startTime));
    }

    if (endTime != null) {
      query.where((sample) => sample.timestamp.isSmallerOrEqualValue(endTime));
    }

    query.orderBy([(sample) => OrderingTerm.asc(sample.timestamp)]);

    if (offset != null) {
      query.limit(limit ?? 1000, offset: offset);
    } else if (limit != null) {
      query.limit(limit);
    }

    final entities = await query.get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<void> saveHrvSamples(List<HrvSample> samples) async {
    if (samples.isEmpty) return;

    await _database.batch((batch) {
      for (final sample in samples) {
        batch.insert(_database.hrvSamples, sample.toCompanion());
      }
    });
  }

  @override
  Future<List<HrvSample>> getHrvSamples(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  }) async {
    final query = _database.select(_database.hrvSamples)
      ..where((sample) => sample.sessionId.equals(sessionId));

    if (startTime != null) {
      query.where((sample) => sample.timestamp.isBiggerOrEqualValue(startTime));
    }

    if (endTime != null) {
      query.where((sample) => sample.timestamp.isSmallerOrEqualValue(endTime));
    }

    query.orderBy([(sample) => OrderingTerm.asc(sample.timestamp)]);

    if (limit != null) {
      query.limit(limit);
    }

    final entities = await query.get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<int> getHeartRateSampleCount(String sessionId) async {
    final result =
        await (_database.selectOnly(_database.heartRateSamples)
              ..addColumns([_database.heartRateSamples.id.count()])
              ..where(_database.heartRateSamples.sessionId.equals(sessionId)))
            .getSingle();
    return result.read(_database.heartRateSamples.id.count()) ?? 0;
  }

  @override
  Future<void> deleteHeartRateSamples(String sessionId) async {
    await _database.transaction(() async {
      await (_database.delete(
        _database.heartRateSamples,
      )..where((sample) => sample.sessionId.equals(sessionId))).go();

      await (_database.delete(
        _database.hrvSamples,
      )..where((sample) => sample.sessionId.equals(sessionId))).go();
    });
  }

  // Data optimization operations

  @override
  Future<void> optimizeSessionData(String sessionId) async {
    // This would implement data chunking and optimization
    // For now, we'll just clean up old individual samples that have been batched

    await _database.transaction(() async {
      // Get batched data timeframes
      final batches =
          await (_database.select(_database.ecgSampleBatches)
                ..where((batch) => batch.sessionId.equals(sessionId))
                ..orderBy([(batch) => OrderingTerm.asc(batch.startTimestamp)]))
              .get();

      // Remove individual samples that are covered by batches
      for (final batch in batches) {
        await (_database.delete(_database.ecgSamples)..where(
              (sample) =>
                  sample.sessionId.equals(sessionId) &
                  sample.timestamp.isBiggerOrEqualValue(batch.startTimestamp) &
                  sample.timestamp.isSmallerOrEqualValue(batch.endTimestamp),
            ))
            .go();
      }
    });
  }

  @override
  Future<StorageStatistics> getStorageStatistics() async {
    final sessionCount = await _database
        .customSelect('SELECT COUNT(*) as count FROM measurement_sessions')
        .getSingle()
        .then((row) => row.read<int>('count'));

    final ecgSampleCount = await _database
        .customSelect('SELECT COUNT(*) as count FROM ecg_samples')
        .getSingle()
        .then((row) => row.read<int>('count'));

    final hrSampleCount = await _database
        .customSelect('SELECT COUNT(*) as count FROM heart_rate_samples')
        .getSingle()
        .then((row) => row.read<int>('count'));

    final hrvSampleCount = await _database
        .customSelect('SELECT COUNT(*) as count FROM hrv_samples')
        .getSingle()
        .then((row) => row.read<int>('count'));

    // Estimate database size (this is a rough approximation)
    final databaseSizeMB =
        (sessionCount * 0.001 +
        ecgSampleCount * 0.0001 +
        hrSampleCount * 0.0001 +
        hrvSampleCount * 0.0001);

    return StorageStatistics(
      totalSessions: sessionCount,
      totalEcgSamples: ecgSampleCount,
      totalHeartRateSamples: hrSampleCount,
      totalHrvSamples: hrvSampleCount,
      databaseSizeMB: databaseSizeMB,
      lastOptimized: DateTime.now(),
    );
  }

  // Compression utilities moved to `compression_utils.dart` and imported above.
}
