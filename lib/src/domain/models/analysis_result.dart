import 'hrv_metrics.dart';
import 'heart_rate_analysis.dart';
import 'stress_indicator.dart';

/// Analysis result model combining all analysis components
/// 
/// This is the main result container for completed analysis as specified
/// in the development plan's domain models section
class AnalysisResult {
  const AnalysisResult({
    required this.sessionId,
    required this.analyzedAt,
    required this.hrvMetrics,
    required this.heartRateAnalysis,
    required this.stressIndicator,
    this.qualityScore,
    this.aiInsights,
    this.validationMetrics,
    this.processingTimeMs,
  });

  /// ID of the measurement session this analysis belongs to
  final String sessionId;

  /// When this analysis was completed
  final DateTime analyzedAt;

  /// Heart Rate Variability metrics
  final HrvMetrics hrvMetrics;

  /// Heart rate analysis results
  final HeartRateAnalysis heartRateAnalysis;

  /// Stress indicators and autonomic balance
  final StressIndicator stressIndicator;

  /// Overall quality score of the analysis (0.0-1.0) - optional
  final double? qualityScore;

  /// AI-generated insights and interpretations - optional
  final AiInsights? aiInsights;

  /// Validation metrics for quality assurance - optional
  final ValidationMetrics? validationMetrics;

  /// Time taken to process this analysis in milliseconds - optional
  final int? processingTimeMs;

  @override
  String toString() {
    return 'AnalysisResult(sessionId: $sessionId, analyzedAt: $analyzedAt, qualityScore: $qualityScore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalysisResult &&
        other.sessionId == sessionId &&
        other.analyzedAt == analyzedAt &&
        other.hrvMetrics == hrvMetrics &&
        other.heartRateAnalysis == heartRateAnalysis &&
        other.stressIndicator == stressIndicator &&
        other.qualityScore == qualityScore &&
        other.aiInsights == aiInsights &&
        other.validationMetrics == validationMetrics &&
        other.processingTimeMs == processingTimeMs;
  }

  @override
  int get hashCode {
    return Object.hash(
      sessionId,
      analyzedAt,
      hrvMetrics,
      heartRateAnalysis,
      stressIndicator,
      qualityScore,
      aiInsights,
      validationMetrics,
      processingTimeMs,
    );
  }
}

/// AI-generated insights and interpretations
class AiInsights {
  const AiInsights({
    required this.summary,
    required this.recommendations,
    required this.confidence,
    this.detailedAnalysis,
    this.warnings,
    this.modelVersion,
  });

  /// Brief summary of the analysis
  final String summary;

  /// AI-generated recommendations
  final List<String> recommendations;

  /// Confidence level of AI analysis (0.0-1.0)
  final double confidence;

  /// Detailed analysis text - optional
  final String? detailedAnalysis;

  /// Any warnings or alerts - optional
  final List<String>? warnings;

  /// Version of the AI model used - optional
  final String? modelVersion;

  @override
  String toString() {
    return 'AiInsights(summary: $summary, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AiInsights &&
        other.summary == summary &&
        _listEquals(other.recommendations, recommendations) &&
        other.confidence == confidence &&
        other.detailedAnalysis == detailedAnalysis &&
        _listEquals(other.warnings, warnings) &&
        other.modelVersion == modelVersion;
  }

  @override
  int get hashCode {
    return Object.hash(
      summary,
      Object.hashAll(recommendations),
      confidence,
      detailedAnalysis,
      Object.hashAll(warnings ?? []),
      modelVersion,
    );
  }
}

/// Validation metrics for quality assurance
class ValidationMetrics {
  const ValidationMetrics({
    required this.accuracy,
    required this.sensitivity,
    required this.specificity,
    this.precision,
    this.recall,
    this.f1Score,
  });

  /// Accuracy metric (0.0-1.0)
  final double accuracy;

  /// Sensitivity metric (0.0-1.0)
  final double sensitivity;

  /// Specificity metric (0.0-1.0)
  final double specificity;

  /// Precision metric (0.0-1.0) - optional
  final double? precision;

  /// Recall metric (0.0-1.0) - optional
  final double? recall;

  /// F1 score (0.0-1.0) - optional
  final double? f1Score;

  @override
  String toString() {
    return 'ValidationMetrics(accuracy: $accuracy, sensitivity: $sensitivity, specificity: $specificity)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ValidationMetrics &&
        other.accuracy == accuracy &&
        other.sensitivity == sensitivity &&
        other.specificity == specificity &&
        other.precision == precision &&
        other.recall == recall &&
        other.f1Score == f1Score;
  }

  @override
  int get hashCode {
    return Object.hash(
      accuracy,
      sensitivity,
      specificity,
      precision,
      recall,
      f1Score,
    );
  }
}

/// Helper function to compare lists
bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}