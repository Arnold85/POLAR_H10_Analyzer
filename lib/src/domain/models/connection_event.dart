import 'package:json_annotation/json_annotation.dart';
import 'polar_device.dart';

part 'connection_event.g.dart';

/// Represents a connection state change for a specific device.
/// The actual connection state enum is `DeviceConnectionStatus` (see `polar_device.dart`).
@JsonSerializable()
class ConnectionEvent {
  final String deviceId;
  final DeviceConnectionStatus state;

  ConnectionEvent(this.deviceId, this.state);

  factory ConnectionEvent.fromJson(Map<String, dynamic> json) =>
      _$ConnectionEventFromJson(json);

  Map<String, dynamic> toJson() => _$ConnectionEventToJson(this);
}
