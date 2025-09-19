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
}