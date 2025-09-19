import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/models/measurement_session.dart';
import '../../domain/repositories/session_repository.dart';
import '../datasources/local/app_database.dart';
import '../models/data_mappers.dart';

/// Concrete implementation of SessionRepository using Drift database
class DriftSessionRepository implements SessionRepository {
  final AppDatabase _database;

  const DriftSessionRepository(this._database);

  @override
  Future<List<MeasurementSession>> getSessions() async {
    final entities = await (_database.select(_database.measurementSessions)
          ..orderBy([(session) => OrderingTerm.desc(session.startTime)]))
        .get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<List<MeasurementSession>> getSessionsFiltered({
    String? deviceId,
    SessionStatus? status,
    SessionType? type,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
  }) async {
    final query = _database.select(_database.measurementSessions);

    if (deviceId != null) {
      query.where((session) => session.deviceId.equals(deviceId));
    }

    if (status != null) {
      query.where((session) => session.status.equals(status.name));
    }

    if (type != null) {
      query.where((session) => session.type.equals(type.name));
    }

    if (startDate != null) {
      query.where((session) => session.startTime.isBiggerOrEqualValue(startDate));
    }

    if (endDate != null) {
      query.where((session) => session.startTime.isSmallerOrEqualValue(endDate));
    }

    if (tags != null && tags.isNotEmpty) {
      for (final tag in tags) {
        query.where((session) => session.tags.like('%"$tag"%'));
      }
    }

    query.orderBy([(session) => OrderingTerm.desc(session.startTime)]);

    final entities = await query.get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<MeasurementSession?> getSession(String sessionId) async {
    final entity = await (_database.select(_database.measurementSessions)
          ..where((session) => session.sessionId.equals(sessionId)))
        .getSingleOrNull();

    return entity?.toDomainModel();
  }

  @override
  Future<String> createSession(MeasurementSession session) async {
    await _database.into(_database.measurementSessions).insert(
      session.toCompanion(),
    );
    return session.sessionId;
  }

  @override
  Future<void> updateSession(MeasurementSession session) async {
    await (_database.update(_database.measurementSessions)
          ..where((s) => s.sessionId.equals(session.sessionId)))
        .write(session.toUpdateCompanion());
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await _database.transaction(() async {
      // Delete all related data first
      await (_database.delete(_database.ecgSamples)
            ..where((sample) => sample.sessionId.equals(sessionId)))
          .go();
      
      await (_database.delete(_database.ecgSampleBatches)
            ..where((batch) => batch.sessionId.equals(sessionId)))
          .go();
      
      await (_database.delete(_database.heartRateSamples)
            ..where((sample) => sample.sessionId.equals(sessionId)))
          .go();
      
      await (_database.delete(_database.hrvSamples)
            ..where((sample) => sample.sessionId.equals(sessionId)))
          .go();
      
      await (_database.delete(_database.analysisResults)
            ..where((result) => result.sessionId.equals(sessionId)))
          .go();
      
      await (_database.delete(_database.exportHistory)
            ..where((export) => export.sessionId.equals(sessionId)))
          .go();

      // Finally delete the session
      await (_database.delete(_database.measurementSessions)
            ..where((session) => session.sessionId.equals(sessionId)))
          .go();
    });
  }

  @override
  Future<SessionStatistics> getSessionStatistics(String sessionId) async {
    final ecgCount = await (_database.selectOnly(_database.ecgSamples)
          ..addColumns([_database.ecgSamples.id.count()])
          ..where(_database.ecgSamples.sessionId.equals(sessionId)))
        .getSingle()
        .then((row) => row.read(_database.ecgSamples.id.count()) ?? 0);

    final hrCount = await (_database.selectOnly(_database.heartRateSamples)
          ..addColumns([_database.heartRateSamples.id.count()])
          ..where(_database.heartRateSamples.sessionId.equals(sessionId)))
        .getSingle()
        .then((row) => row.read(_database.heartRateSamples.id.count()) ?? 0);

    final analysisCount = await (_database.selectOnly(_database.analysisResults)
          ..addColumns([_database.analysisResults.analysisId.count()])
          ..where(_database.analysisResults.sessionId.equals(sessionId)))
        .getSingle()
        .then((row) => row.read(_database.analysisResults.analysisId.count()) ?? 0);

    // Get first and last sample times
    final firstEcgSample = await (_database.select(_database.ecgSamples)
          ..where((sample) => sample.sessionId.equals(sessionId))
          ..orderBy([(sample) => OrderingTerm.asc(sample.timestamp)])
          ..limit(1))
        .getSingleOrNull();

    final lastEcgSample = await (_database.select(_database.ecgSamples)
          ..where((sample) => sample.sessionId.equals(sessionId))
          ..orderBy([(sample) => OrderingTerm.desc(sample.timestamp)])
          ..limit(1))
        .getSingleOrNull();

    return SessionStatistics(
      sessionId: sessionId,
      totalEcgSamples: ecgCount,
      totalHeartRateSamples: hrCount,
      analysisCount: analysisCount,
      firstSampleTime: firstEcgSample?.timestamp,
      lastSampleTime: lastEcgSample?.timestamp,
    );
  }

  @override
  Future<List<MeasurementSession>> getRecentSessions(int limit) async {
    final entities = await (_database.select(_database.measurementSessions)
          ..orderBy([(session) => OrderingTerm.desc(session.startTime)])
          ..limit(limit))
        .get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }
}

/// Extension to convert database entity to domain model for sessions
extension MeasurementSessionEntityToDomain on MeasurementSessionData {
  MeasurementSession toDomainModel() {
    return MeasurementSession(
      sessionId: sessionId,
      deviceId: deviceId,
      startTime: startTime,
      endTime: endTime,
      status: SessionStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => SessionStatus.preparing,
      ),
      type: SessionType.values.firstWhere(
        (t) => t.name == type,
        orElse: () => SessionType.general,
      ),
      tags: tags != null && tags!.isNotEmpty 
          ? List<String>.from(jsonDecode(tags!)) 
          : [],
      notes: notes,
    );
  }
}