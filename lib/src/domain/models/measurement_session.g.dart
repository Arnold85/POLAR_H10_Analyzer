// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasurementSession _$MeasurementSessionFromJson(Map<String, dynamic> json) =>
    MeasurementSession(
      sessionId: json['sessionId'] as String,
      deviceId: json['deviceId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status: $enumDecode(_$SessionStatusEnumMap, json['status']),
      type: $enumDecode(_$SessionTypeEnumMap, json['type']),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$MeasurementSessionToJson(MeasurementSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'deviceId': instance.deviceId,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'status': _$SessionStatusEnumMap[instance.status]!,
      'type': _$SessionTypeEnumMap[instance.type]!,
      'tags': instance.tags,
      'notes': instance.notes,
    };

const _$SessionStatusEnumMap = {
  SessionStatus.preparing: 'preparing',
  SessionStatus.recording: 'recording',
  SessionStatus.paused: 'paused',
  SessionStatus.completed: 'completed',
  SessionStatus.cancelled: 'cancelled',
  SessionStatus.error: 'error',
};

const _$SessionTypeEnumMap = {
  SessionType.resting: 'resting',
  SessionType.exercise: 'exercise',
  SessionType.stressTest: 'stress_test',
  SessionType.recovery: 'recovery',
  SessionType.sleep: 'sleep',
  SessionType.general: 'general',
};
