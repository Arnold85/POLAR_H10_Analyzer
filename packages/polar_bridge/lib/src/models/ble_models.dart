import 'package:meta/meta.dart';

@immutable
class PolarDevice {
  final String id;
  final String name;
  final int? rssi;
  const PolarDevice({required this.id, required this.name, this.rssi});
}

@immutable
class HeartRateSample {
  final int hr;
  final List<int> rrIntervalsMs; // RR intervals in milliseconds
  final DateTime timestamp;
  const HeartRateSample({
    required this.hr,
    required this.rrIntervalsMs,
    required this.timestamp,
  });
}

@immutable
class EcgSampleBatch {
  final List<int> samples; // raw microvolt values
  final int samplingRate; // Hz
  final DateTime receivedAt;
  const EcgSampleBatch({
    required this.samples,
    required this.samplingRate,
    required this.receivedAt,
  });
}

enum PolarConnectionState { disconnected, connecting, connected }

@immutable
class ConnectionEvent {
  final String deviceId;
  final PolarConnectionState state;
  const ConnectionEvent(this.deviceId, this.state);
}

@immutable
class BatteryLevelEvent {
  final String deviceId;
  final int level; // percentage 0-100
  const BatteryLevelEvent(this.deviceId, this.level);
}
