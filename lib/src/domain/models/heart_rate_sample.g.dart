// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heart_rate_sample.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeartRateSample _$HeartRateSampleFromJson(Map<String, dynamic> json) =>
    HeartRateSample(
      sessionId: json['sessionId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      heartRate: (json['heartRate'] as num).toInt(),
      rrIntervals:
          (json['rrIntervals'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      contactDetected: json['contactDetected'] as bool,
      quality: (json['quality'] as num?)?.toInt(),
      source: $enumDecode(_$HeartRateSourceEnumMap, json['source']),
    );

Map<String, dynamic> _$HeartRateSampleToJson(HeartRateSample instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'timestamp': instance.timestamp.toIso8601String(),
      'heartRate': instance.heartRate,
      'rrIntervals': instance.rrIntervals,
      'contactDetected': instance.contactDetected,
      'quality': instance.quality,
      'source': _$HeartRateSourceEnumMap[instance.source]!,
    };

const _$HeartRateSourceEnumMap = {
  HeartRateSource.ecg: 'ecg',
  HeartRateSource.optical: 'optical',
  HeartRateSource.chestStrap: 'chest_strap',
  HeartRateSource.calculated: 'calculated',
};

HrvSample _$HrvSampleFromJson(Map<String, dynamic> json) => HrvSample(
  sessionId: json['sessionId'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  rrIntervals: (json['rrIntervals'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  windowSeconds: (json['windowSeconds'] as num).toInt(),
  rmssd: (json['rmssd'] as num?)?.toDouble(),
  sdnn: (json['sdnn'] as num?)?.toDouble(),
  pnn50: (json['pnn50'] as num?)?.toDouble(),
  meanRR: (json['meanRR'] as num?)?.toDouble(),
  heartRate: (json['heartRate'] as num?)?.toDouble(),
  stressIndex: (json['stressIndex'] as num?)?.toInt(),
);

Map<String, dynamic> _$HrvSampleToJson(HrvSample instance) => <String, dynamic>{
  'sessionId': instance.sessionId,
  'timestamp': instance.timestamp.toIso8601String(),
  'rrIntervals': instance.rrIntervals,
  'windowSeconds': instance.windowSeconds,
  'rmssd': instance.rmssd,
  'sdnn': instance.sdnn,
  'pnn50': instance.pnn50,
  'meanRR': instance.meanRR,
  'heartRate': instance.heartRate,
  'stressIndex': instance.stressIndex,
};
