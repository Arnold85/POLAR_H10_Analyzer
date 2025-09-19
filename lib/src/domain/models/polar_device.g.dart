// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polar_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PolarDevice _$PolarDeviceFromJson(Map<String, dynamic> json) => PolarDevice(
  deviceId: json['deviceId'] as String,
  name: json['name'] as String,
  firmwareVersion: json['firmwareVersion'] as String?,
  batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
  connectionStatus: $enumDecode(
    _$DeviceConnectionStatusEnumMap,
    json['connectionStatus'],
  ),
  signalQuality: (json['signalQuality'] as num?)?.toInt(),
  electrodeStatus: $enumDecode(
    _$ElectrodeStatusEnumMap,
    json['electrodeStatus'],
  ),
  lastSeen: DateTime.parse(json['lastSeen'] as String),
);

Map<String, dynamic> _$PolarDeviceToJson(PolarDevice instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'name': instance.name,
      'firmwareVersion': instance.firmwareVersion,
      'batteryLevel': instance.batteryLevel,
      'connectionStatus':
          _$DeviceConnectionStatusEnumMap[instance.connectionStatus]!,
      'signalQuality': instance.signalQuality,
      'electrodeStatus': _$ElectrodeStatusEnumMap[instance.electrodeStatus]!,
      'lastSeen': instance.lastSeen.toIso8601String(),
    };

const _$DeviceConnectionStatusEnumMap = {
  DeviceConnectionStatus.disconnected: 'disconnected',
  DeviceConnectionStatus.connecting: 'connecting',
  DeviceConnectionStatus.connected: 'connected',
  DeviceConnectionStatus.error: 'error',
};

const _$ElectrodeStatusEnumMap = {
  ElectrodeStatus.unknown: 'unknown',
  ElectrodeStatus.poor: 'poor',
  ElectrodeStatus.good: 'good',
  ElectrodeStatus.excellent: 'excellent',
};
