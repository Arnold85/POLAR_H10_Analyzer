
import 'package:json_annotation/json_annotation.dart';

part 'analysis_result.g.dart';

/// Domain model representing analysis results for a session
@JsonSerializable()
class AnalysisResult {
  /// Unique analysis result identifier
  final String analysisId;
  
  /// Session this analysis belongs to
  final String sessionId;
  
  /// Type of analysis performed
  final AnalysisType analysisType;
  
  /// Timestamp when analysis was performed
  final DateTime analysisTimestamp;
  
  /// Version of the analysis algorithm used
  final String algorithmVersion;
  
  /// Overall analysis status
  final AnalysisStatus status;
  
  /// Analysis results data
  final AnalysisData data;
  
  /// Confidence level of the analysis (0-100)
  final int? confidence;
  
  /// Error message if analysis failed
  final String? errorMessage;
  
  /// Processing time in milliseconds
  final int? processingTimeMs;

  const AnalysisResult({
    required this.analysisId,
    required this.sessionId,
    required this.analysisType,
    required this.analysisTimestamp,
    required this.algorithmVersion,
    required this.status,
    required this.data,
    this.confidence,
    this.errorMessage,
    this.processingTimeMs,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisResultToJson(this);

  AnalysisResult copyWith({
    String? analysisId,
    String? sessionId,
    AnalysisType? analysisType,
    DateTime? analysisTimestamp,
    String? algorithmVersion,
    AnalysisStatus? status,
    AnalysisData? data,
    int? confidence,
    String? errorMessage,
    int? processingTimeMs,
  }) {
    return AnalysisResult(
      analysisId: analysisId ?? this.analysisId,
      sessionId: sessionId ?? this.sessionId,
      analysisType: analysisType ?? this.analysisType,
      analysisTimestamp: analysisTimestamp ?? this.analysisTimestamp,
      algorithmVersion: algorithmVersion ?? this.algorithmVersion,
      status: status ?? this.status,
      data: data ?? this.data,
      confidence: confidence ?? this.confidence,
      errorMessage: errorMessage ?? this.errorMessage,
      processingTimeMs: processingTimeMs ?? this.processingTimeMs,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalysisResult &&
          runtimeType == other.runtimeType &&
          analysisId == other.analysisId;

  @override
  int get hashCode => analysisId.hashCode;

  @override
  String toString() {
    return 'AnalysisResult{analysisId: $analysisId, type: $analysisType, status: $status, confidence: $confidence}';
  }
}

/// Analysis result data container
@JsonSerializable()
class AnalysisData {
  /// Statistical metrics
  final StatisticalMetrics? statistical;
  
  /// HRV (Heart Rate Variability) metrics
  final HrvMetrics? hrv;
  
  /// Frequency domain metrics
  final FrequencyMetrics? frequency;
  
  /// AI-generated insights
  final AiInsights? aiInsights;
  
  /// Custom analysis metrics
  final Map<String, dynamic>? customMetrics;

  const AnalysisData({
    this.statistical,
    this.hrv,
    this.frequency,
    this.aiInsights,
    this.customMetrics,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDataFromJson(json);

  Map<String, dynamic> toJson() => _$AnalysisDataToJson(this);
}

/// Statistical metrics for heart rate analysis
@JsonSerializable()
class StatisticalMetrics {
  /// Mean heart rate (BPM)
  final double meanHeartRate;
  
  /// Minimum heart rate (BPM)
  final int minHeartRate;
  
  /// Maximum heart rate (BPM)
  final int maxHeartRate;
  
  /// Standard deviation of heart rate
  final double heartRateStd;
  
  /// Total number of heartbeats
  final int totalBeats;
  
  /// Average RR interval (ms)
  final double meanRR;

  const StatisticalMetrics({
    required this.meanHeartRate,
    required this.minHeartRate,
    required this.maxHeartRate,
    required this.heartRateStd,
    required this.totalBeats,
    required this.meanRR,
  });

  factory StatisticalMetrics.fromJson(Map<String, dynamic> json) =>
      _$StatisticalMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticalMetricsToJson(this);
}

/// HRV (Heart Rate Variability) metrics
@JsonSerializable()
class HrvMetrics {
  /// RMSSD - Root Mean Square of Successive Differences (ms)
  final double rmssd;
  
  /// SDNN - Standard Deviation of NN intervals (ms)
  final double sdnn;
  
  /// pNN50 - Percentage of NN intervals > 50ms different from previous
  final double pnn50;
  
  /// Triangular index
  final double? triangularIndex;
  
  /// Stress index (0-100)
  final int stressIndex;
  
  /// Autonomic balance indicator
  final AutonomicBalance autonomicBalance;

  const HrvMetrics({
    required this.rmssd,
    required this.sdnn,
    required this.pnn50,
    this.triangularIndex,
    required this.stressIndex,
    required this.autonomicBalance,
  });

  factory HrvMetrics.fromJson(Map<String, dynamic> json) =>
      _$HrvMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$HrvMetricsToJson(this);
}

/// Frequency domain analysis metrics
@JsonSerializable()
class FrequencyMetrics {
  /// Very Low Frequency power (ms²)
  final double vlf;
  
  /// Low Frequency power (ms²)
  final double lf;
  
  /// High Frequency power (ms²)
  final double hf;
  
  /// LF/HF ratio
  final double lfHfRatio;
  
  /// Total power (ms²)
  final double totalPower;

  const FrequencyMetrics({
    required this.vlf,
    required this.lf,
    required this.hf,
    required this.lfHfRatio,
    required this.totalPower,
  });

  factory FrequencyMetrics.fromJson(Map<String, dynamic> json) =>
      _$FrequencyMetricsFromJson(json);

  Map<String, dynamic> toJson() => _$FrequencyMetricsToJson(this);
}

/// AI-generated insights and interpretations
@JsonSerializable()
class AiInsights {
  /// Overall health assessment
  final String? healthAssessment;
  
  /// Stress level interpretation
  final String? stressInterpretation;
  
  /// Recovery recommendations
  final List<String> recommendations;
  
  /// Detected patterns or anomalies
  final List<String> patterns;
  
  /// Confidence in AI analysis (0-100)
  final int confidence;

  const AiInsights({
    this.healthAssessment,
    this.stressInterpretation,
    this.recommendations = const [],
    this.patterns = const [],
    required this.confidence,
  });

  factory AiInsights.fromJson(Map<String, dynamic> json) =>
      _$AiInsightsFromJson(json);

  Map<String, dynamic> toJson() => _$AiInsightsToJson(this);
}

/// Types of analysis that can be performed
enum AnalysisType {
  @JsonValue('hrv')
  hrv,
  @JsonValue('statistical')
  statistical,
  @JsonValue('frequency')
  frequency,
  @JsonValue('ai_comprehensive')
  aiComprehensive,
  @JsonValue('anomaly_detection')
  anomalyDetection,
  @JsonValue('stress_analysis')
  stressAnalysis,
}

/// Status of analysis execution
enum AnalysisStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('running')
  running,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
}

/// Autonomic nervous system balance
enum AutonomicBalance {
  @JsonValue('sympathetic_dominant')
  sympatheticDominant,
  @JsonValue('parasympathetic_dominant')
  parasympatheticDominant,
  @JsonValue('balanced')
  balanced,
  @JsonValue('unknown')
  unknown,
=======
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