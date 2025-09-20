import 'dart:convert';
import 'package:drift/drift.dart';
import '../../domain/models/analysis_result.dart';
import '../../domain/repositories/analysis_repository.dart';
import '../datasources/local/app_database.dart' as db;
import '../models/data_mappers.dart';

/// Concrete implementation of AnalysisRepository using Drift database
class DriftAnalysisRepository implements AnalysisRepository {
  final db.AppDatabase _database;

  const DriftAnalysisRepository(this._database);

  @override
  Future<void> saveAnalysisResult(AnalysisResult result) async {
    await _database
        .into(_database.analysisResults)
        .insertOnConflictUpdate(result.toCompanion());
  }

  @override
  Future<List<AnalysisResult>> getAnalysisResults(
    String sessionId, {
    AnalysisType? type,
    AnalysisStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final query = _database.select(_database.analysisResults)
      ..where((result) => result.sessionId.equals(sessionId));

    if (type != null) {
      query.where((result) => result.analysisType.equals(type.name));
    }

    if (status != null) {
      query.where((result) => result.status.equals(status.name));
    }

    if (startDate != null) {
      query.where(
        (result) => result.analysisTimestamp.isBiggerOrEqualValue(startDate),
      );
    }

    if (endDate != null) {
      query.where(
        (result) => result.analysisTimestamp.isSmallerOrEqualValue(endDate),
      );
    }

    query.orderBy([(result) => OrderingTerm.desc(result.analysisTimestamp)]);

    final entities = await query.get();
    return entities.map((entity) => entity.toDomainModel()).toList();
  }

  @override
  Future<AnalysisResult?> getAnalysisResult(String analysisId) async {
    final entity =
        await (_database.select(_database.analysisResults)
              ..where((result) => result.analysisId.equals(analysisId)))
            .getSingleOrNull();

    return entity?.toDomainModel();
  }

  @override
  Future<void> updateAnalysisStatus(
    String analysisId,
    AnalysisStatus status, {
    String? errorMessage,
  }) async {
    await (_database.update(
      _database.analysisResults,
    )..where((result) => result.analysisId.equals(analysisId))).write(
      db.AnalysisResultsCompanion(
        status: Value(status.name),
        errorMessage: Value(errorMessage),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> updateAnalysisData(
    String analysisId,
    AnalysisData data, {
    int? confidence,
    int? processingTimeMs,
  }) async {
    await (_database.update(
      _database.analysisResults,
    )..where((result) => result.analysisId.equals(analysisId))).write(
      db.AnalysisResultsCompanion(
        data: Value(jsonEncode(data.toJson())),
        confidence: Value(confidence),
        processingTimeMs: Value(processingTimeMs),
        status: Value(AnalysisStatus.completed.name),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<void> deleteAnalysisResult(String analysisId) async {
    await (_database.delete(
      _database.analysisResults,
    )..where((result) => result.analysisId.equals(analysisId))).go();
  }

  @override
  Future<void> deleteSessionAnalysis(String sessionId) async {
    await (_database.delete(
      _database.analysisResults,
    )..where((result) => result.sessionId.equals(sessionId))).go();
  }

  @override
  Future<AnalysisResult?> getLatestAnalysis(
    String sessionId,
    AnalysisType type,
  ) async {
    final entity =
        await (_database.select(_database.analysisResults)
              ..where(
                (result) =>
                    result.sessionId.equals(sessionId) &
                    result.analysisType.equals(type.name),
              )
              ..orderBy([
                (result) => OrderingTerm.desc(result.analysisTimestamp),
              ])
              ..limit(1))
            .getSingleOrNull();

    return entity?.toDomainModel();
  }

  @override
  Future<AnalysisSummary> getAnalysisSummary(String sessionId) async {
    final allAnalyses = await (_database.select(
      _database.analysisResults,
    )..where((result) => result.sessionId.equals(sessionId))).get();

    final totalAnalyses = allAnalyses.length;
    final completedAnalyses = allAnalyses
        .where((analysis) => analysis.status == AnalysisStatus.completed.name)
        .length;
    final failedAnalyses = allAnalyses
        .where((analysis) => analysis.status == AnalysisStatus.failed.name)
        .length;

    final analysesByType = <AnalysisType, int>{};
    for (final analysis in allAnalyses) {
      final type = AnalysisType.values.firstWhere(
        (t) => t.name == analysis.analysisType,
        orElse: () => AnalysisType.statistical,
      );
      analysesByType[type] = (analysesByType[type] ?? 0) + 1;
    }

    final lastAnalysisTime = allAnalyses.isNotEmpty
        ? allAnalyses
              .map((a) => a.analysisTimestamp)
              .reduce((a, b) => a.isAfter(b) ? a : b)
        : null;

    final completedWithConfidence = allAnalyses
        .where(
          (a) =>
              a.status == AnalysisStatus.completed.name && a.confidence != null,
        )
        .toList();

    final averageConfidence = completedWithConfidence.isNotEmpty
        ? completedWithConfidence
                  .map((a) => a.confidence!)
                  .reduce((a, b) => a + b) /
              completedWithConfidence.length
        : null;

    return AnalysisSummary(
      sessionId: sessionId,
      totalAnalyses: totalAnalyses,
      completedAnalyses: completedAnalyses,
      failedAnalyses: failedAnalyses,
      analysesByType: analysesByType,
      lastAnalysisTime: lastAnalysisTime,
      averageConfidence: averageConfidence,
    );
  }
}

// Note: mapping extension moved to `data_mappers.dart` to avoid ambiguous imports and centralize mappings.
