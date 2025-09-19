import 'package:json_annotation/json_annotation.dart';

part 'polar_device.g.dart';

/// Domain model representing a Polar H10 device
@JsonSerializable()
class PolarDevice {
  /// Unique device identifier (MAC address or similar)
  final String deviceId;
  
  /// Human-readable device name
  final String name;
  
  /// Device firmware version
  final String? firmwareVersion;
  
  /// Device battery level (0-100)
  final int? batteryLevel;
  
  /// Connection status
  final DeviceConnectionStatus connectionStatus;
  
  /// Signal quality (0-100)
  final int? signalQuality;
  
  /// Electrode contact status
  final ElectrodeStatus electrodeStatus;
  
  /// Last seen timestamp
  final DateTime lastSeen;

  const PolarDevice({
    required this.deviceId,
    required this.name,
    this.firmwareVersion,
    this.batteryLevel,
    required this.connectionStatus,
    this.signalQuality,
    required this.electrodeStatus,
    required this.lastSeen,
  });

  factory PolarDevice.fromJson(Map<String, dynamic> json) =>
      _$PolarDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$PolarDeviceToJson(this);

  PolarDevice copyWith({
    String? deviceId,
    String? name,
    String? firmwareVersion,
    int? batteryLevel,
    DeviceConnectionStatus? connectionStatus,
    int? signalQuality,
    ElectrodeStatus? electrodeStatus,
    DateTime? lastSeen,
  }) {
    return PolarDevice(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      signalQuality: signalQuality ?? this.signalQuality,
      electrodeStatus: electrodeStatus ?? this.electrodeStatus,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolarDevice &&
          runtimeType == other.runtimeType &&
          deviceId == other.deviceId;

  @override
  int get hashCode => deviceId.hashCode;

  @override
  String toString() {
    return 'PolarDevice{deviceId: $deviceId, name: $name, connectionStatus: $connectionStatus}';
  }
}

/// Device connection status
enum DeviceConnectionStatus {
  @JsonValue('disconnected')
  disconnected,
  @JsonValue('connecting')
  connecting,
  @JsonValue('connected')
  connected,
  @JsonValue('error')
  error,
}

/// Electrode contact status
enum ElectrodeStatus {
  @JsonValue('unknown')
  unknown,
  @JsonValue('poor')
  poor,
  @JsonValue('good')
  good,
  @JsonValue('excellent')
  excellent,
}