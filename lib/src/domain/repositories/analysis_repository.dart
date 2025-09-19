import '../models/analysis_result.dart';

/// Repository interface for analysis result management
abstract class AnalysisRepository {
  /// Save analysis result
  Future<void> saveAnalysisResult(AnalysisResult result);
  
  /// Get analysis results for a session
  Future<List<AnalysisResult>> getAnalysisResults(
    String sessionId, {
    AnalysisType? type,
    AnalysisStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Get analysis result by ID
  Future<AnalysisResult?> getAnalysisResult(String analysisId);
  
  /// Update analysis status
  Future<void> updateAnalysisStatus(
    String analysisId,
    AnalysisStatus status, {
    String? errorMessage,
  });
  
  /// Update analysis result data
  Future<void> updateAnalysisData(
    String analysisId,
    AnalysisData data, {
    int? confidence,
    int? processingTimeMs,
  });
  
  /// Delete analysis result
  Future<void> deleteAnalysisResult(String analysisId);
  
  /// Delete all analysis results for a session
  Future<void> deleteSessionAnalysis(String sessionId);
  
  /// Get latest analysis for a session by type
  Future<AnalysisResult?> getLatestAnalysis(
    String sessionId,
    AnalysisType type,
  );
  
  /// Get analysis summary statistics
  Future<AnalysisSummary> getAnalysisSummary(String sessionId);
}

/// Summary of analysis results for a session
class AnalysisSummary {
  final String sessionId;
  final int totalAnalyses;
  final int completedAnalyses;
  final int failedAnalyses;
  final Map<AnalysisType, int> analysesByType;
  final DateTime? lastAnalysisTime;
  final double? averageConfidence;

  const AnalysisSummary({
    required this.sessionId,
    required this.totalAnalyses,
    required this.completedAnalyses,
    required this.failedAnalyses,
    required this.analysesByType,
    this.lastAnalysisTime,
    this.averageConfidence,
  });
}