// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConnectionEvent _$ConnectionEventFromJson(Map<String, dynamic> json) =>
    ConnectionEvent(
      json['deviceId'] as String,
      $enumDecode(_$DeviceConnectionStatusEnumMap, json['state']),
    );

Map<String, dynamic> _$ConnectionEventToJson(ConnectionEvent instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'state': _$DeviceConnectionStatusEnumMap[instance.state]!,
    };

const _$DeviceConnectionStatusEnumMap = {
  DeviceConnectionStatus.disconnected: 'disconnected',
  DeviceConnectionStatus.connecting: 'connecting',
  DeviceConnectionStatus.connected: 'connected',
  DeviceConnectionStatus.error: 'error',
};
