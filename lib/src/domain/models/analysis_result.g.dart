// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalysisResult _$AnalysisResultFromJson(Map<String, dynamic> json) =>
    AnalysisResult(
      analysisId: json['analysisId'] as String,
      sessionId: json['sessionId'] as String,
      analysisType: $enumDecode(_$AnalysisTypeEnumMap, json['analysisType']),
      analysisTimestamp: DateTime.parse(json['analysisTimestamp'] as String),
      algorithmVersion: json['algorithmVersion'] as String,
      status: $enumDecode(_$AnalysisStatusEnumMap, json['status']),
      data: AnalysisData.fromJson(json['data'] as Map<String, dynamic>),
      confidence: (json['confidence'] as num?)?.toInt(),
      errorMessage: json['errorMessage'] as String?,
      processingTimeMs: (json['processingTimeMs'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AnalysisResultToJson(AnalysisResult instance) =>
    <String, dynamic>{
      'analysisId': instance.analysisId,
      'sessionId': instance.sessionId,
      'analysisType': _$AnalysisTypeEnumMap[instance.analysisType]!,
      'analysisTimestamp': instance.analysisTimestamp.toIso8601String(),
      'algorithmVersion': instance.algorithmVersion,
      'status': _$AnalysisStatusEnumMap[instance.status]!,
      'data': instance.data,
      'confidence': instance.confidence,
      'errorMessage': instance.errorMessage,
      'processingTimeMs': instance.processingTimeMs,
    };

const _$AnalysisTypeEnumMap = {
  AnalysisType.hrv: 'hrv',
  AnalysisType.statistical: 'statistical',
  AnalysisType.frequency: 'frequency',
  AnalysisType.aiComprehensive: 'ai_comprehensive',
  AnalysisType.anomalyDetection: 'anomaly_detection',
  AnalysisType.stressAnalysis: 'stress_analysis',
};

const _$AnalysisStatusEnumMap = {
  AnalysisStatus.pending: 'pending',
  AnalysisStatus.running: 'running',
  AnalysisStatus.completed: 'completed',
  AnalysisStatus.failed: 'failed',
  AnalysisStatus.cancelled: 'cancelled',
};

AnalysisData _$AnalysisDataFromJson(Map<String, dynamic> json) => AnalysisData(
  statistical: json['statistical'] == null
      ? null
      : StatisticalMetrics.fromJson(
          json['statistical'] as Map<String, dynamic>,
        ),
  hrv: json['hrv'] == null
      ? null
      : HrvMetrics.fromJson(json['hrv'] as Map<String, dynamic>),
  frequency: json['frequency'] == null
      ? null
      : FrequencyMetrics.fromJson(json['frequency'] as Map<String, dynamic>),
  aiInsights: json['aiInsights'] == null
      ? null
      : AiInsights.fromJson(json['aiInsights'] as Map<String, dynamic>),
  customMetrics: json['customMetrics'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AnalysisDataToJson(AnalysisData instance) =>
    <String, dynamic>{
      'statistical': instance.statistical,
      'hrv': instance.hrv,
      'frequency': instance.frequency,
      'aiInsights': instance.aiInsights,
      'customMetrics': instance.customMetrics,
    };

StatisticalMetrics _$StatisticalMetricsFromJson(Map<String, dynamic> json) =>
    StatisticalMetrics(
      meanHeartRate: (json['meanHeartRate'] as num).toDouble(),
      minHeartRate: (json['minHeartRate'] as num).toInt(),
      maxHeartRate: (json['maxHeartRate'] as num).toInt(),
      heartRateStd: (json['heartRateStd'] as num).toDouble(),
      totalBeats: (json['totalBeats'] as num).toInt(),
      meanRR: (json['meanRR'] as num).toDouble(),
    );

Map<String, dynamic> _$StatisticalMetricsToJson(StatisticalMetrics instance) =>
    <String, dynamic>{
      'meanHeartRate': instance.meanHeartRate,
      'minHeartRate': instance.minHeartRate,
      'maxHeartRate': instance.maxHeartRate,
      'heartRateStd': instance.heartRateStd,
      'totalBeats': instance.totalBeats,
      'meanRR': instance.meanRR,
    };

HrvMetrics _$HrvMetricsFromJson(Map<String, dynamic> json) => HrvMetrics(
  rmssd: (json['rmssd'] as num).toDouble(),
  sdnn: (json['sdnn'] as num).toDouble(),
  pnn50: (json['pnn50'] as num).toDouble(),
  triangularIndex: (json['triangularIndex'] as num?)?.toDouble(),
  stressIndex: (json['stressIndex'] as num).toInt(),
  autonomicBalance: $enumDecode(
    _$AutonomicBalanceEnumMap,
    json['autonomicBalance'],
  ),
);

Map<String, dynamic> _$HrvMetricsToJson(HrvMetrics instance) =>
    <String, dynamic>{
      'rmssd': instance.rmssd,
      'sdnn': instance.sdnn,
      'pnn50': instance.pnn50,
      'triangularIndex': instance.triangularIndex,
      'stressIndex': instance.stressIndex,
      'autonomicBalance': _$AutonomicBalanceEnumMap[instance.autonomicBalance]!,
    };

const _$AutonomicBalanceEnumMap = {
  AutonomicBalance.sympatheticDominant: 'sympathetic_dominant',
  AutonomicBalance.parasympatheticDominant: 'parasympathetic_dominant',
  AutonomicBalance.balanced: 'balanced',
  AutonomicBalance.unknown: 'unknown',
};

FrequencyMetrics _$FrequencyMetricsFromJson(Map<String, dynamic> json) =>
    FrequencyMetrics(
      vlf: (json['vlf'] as num).toDouble(),
      lf: (json['lf'] as num).toDouble(),
      hf: (json['hf'] as num).toDouble(),
      lfHfRatio: (json['lfHfRatio'] as num).toDouble(),
      totalPower: (json['totalPower'] as num).toDouble(),
    );

Map<String, dynamic> _$FrequencyMetricsToJson(FrequencyMetrics instance) =>
    <String, dynamic>{
      'vlf': instance.vlf,
      'lf': instance.lf,
      'hf': instance.hf,
      'lfHfRatio': instance.lfHfRatio,
      'totalPower': instance.totalPower,
    };

AiInsights _$AiInsightsFromJson(Map<String, dynamic> json) => AiInsights(
  healthAssessment: json['healthAssessment'] as String?,
  stressInterpretation: json['stressInterpretation'] as String?,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  patterns:
      (json['patterns'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  confidence: (json['confidence'] as num).toInt(),
);

Map<String, dynamic> _$AiInsightsToJson(AiInsights instance) =>
    <String, dynamic>{
      'healthAssessment': instance.healthAssessment,
      'stressInterpretation': instance.stressInterpretation,
      'recommendations': instance.recommendations,
      'patterns': instance.patterns,
      'confidence': instance.confidence,
    };
