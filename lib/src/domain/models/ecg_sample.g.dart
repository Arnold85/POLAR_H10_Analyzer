// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ecg_sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EcgSample _$EcgSampleFromJson(Map<String, dynamic> json) => EcgSample(
  sessionId: json['sessionId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  voltage: (json['voltage'] as num).toDouble(),
  sequenceNumber: (json['sequenceNumber'] as num).toInt(),
  quality: (json['quality'] as num?)?.toInt(),
  isRPeak: json['isRPeak'] as bool? ?? false,
  leadId: json['leadId'] as String?,
);

Map<String, dynamic> _$EcgSampleToJson(EcgSample instance) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'timestamp': instance.timestamp.toIso8601String(),
  'voltage': instance.voltage,
  'sequenceNumber': instance.sequenceNumber,
  'quality': instance.quality,
  'isRPeak': instance.isRPeak,
  'leadId': instance.leadId,
};

EcgSampleBatch _$EcgSampleBatchFromJson(Map<String, dynamic> json) =>
    EcgSampleBatch(
      sessionId: json['sessionId'] as String,
      startTimestamp: DateTime.parse(json['startTimestamp'] as String),
      endTimestamp: DateTime.parse(json['endTimestamp'] as String),
      samplingRate: (json['samplingRate'] as num).toDouble(),
      voltages: (json['voltages'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      rPeakIndices:
          (json['rPeakIndices'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      batchNumber: (json['batchNumber'] as num).toInt(),
      quality: json['quality'] == null
          ? null
          : BatchQuality.fromJson(json['quality'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EcgSampleBatchToJson(EcgSampleBatch instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'startTimestamp': instance.startTimestamp.toIso8601String(),
      'endTimestamp': instance.endTimestamp.toIso8601String(),
      'samplingRate': instance.samplingRate,
      'voltages': instance.voltages,
      'rPeakIndices': instance.rPeakIndices,
      'batchNumber': instance.batchNumber,
      'quality': instance.quality?.toJson(),
    };

BatchQuality _$BatchQualityFromJson(Map<String, dynamic> json) => BatchQuality(
  averageQuality: (json['averageQuality'] as num).toInt(),
  snr: (json['snr'] as num?)?.toDouble(),
  artifactCount: (json['artifactCount'] as num).toInt(),
  baselineWander: (json['baselineWander'] as num?)?.toDouble(),
);

Map<String, dynamic> _$BatchQualityToJson(BatchQuality instance) =>
    <String, dynamic>{
      'averageQuality': instance.averageQuality,
      'snr': instance.snr,
      'artifactCount': instance.artifactCount,
      'baselineWander': instance.baselineWander,
    };
