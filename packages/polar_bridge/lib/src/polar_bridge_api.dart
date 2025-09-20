import 'dart:async';
import 'package:flutter/services.dart';
import 'models/ble_models.dart';

/// Public Dart API for Polar bridge.
class PolarBridge {
  PolarBridge._();
  static final PolarBridge instance = PolarBridge._();

  static const MethodChannel _method = MethodChannel('polar_bridge/methods');
  static const EventChannel _events = EventChannel('polar_bridge/events');

  Stream<dynamic>? _eventStream;
  // Test-only controller: supplies events when running unit tests. If non-null, tests may push events
  // with `PolarBridge.emitTestEvent(...)`.
  static StreamController<dynamic>? _testController;

  Stream<dynamic> get _rawEvents =>
      _eventStream ??= _events.receiveBroadcastStream().asBroadcastStream();

  // Internal: return test stream if present, otherwise platform EventChannel
  Stream<dynamic> get _testableRawEvents =>
      _testController?.stream ?? _rawEvents;

  /// Public raw events stream (maps from platform EventChannel)
  /// Public raw events stream (maps from platform EventChannel).
  /// When running unit tests, `PolarBridge.setTestController(...)` can be used to inject
  /// a stream controller which will be used instead of the platform EventChannel.
  Stream<dynamic> get events => _testController?.stream ?? _rawEvents;

  /// Test helper: install a test controller to emit events from unit tests.
  /// Call with a non-null controller before creating service instances.
  static void setTestController(StreamController<dynamic>? controller) {
    _testController = controller;
  }

  /// Test helper: convenience to emit a single event on the installed test controller.
  static void emitTestEvent(dynamic event) {
    if (_testController == null)
      throw StateError(
        'Test controller not set. Call setTestController first.',
      );
    _testController!.add(event);
  }

  Stream<ConnectionEvent> get connectionEvents =>
      _rawEvents.where((e) => e['type'] == 'connection').map((e) {
        final state = PolarConnectionState.values.firstWhere(
          (s) => s.name == e['state'],
          orElse: () => PolarConnectionState.disconnected,
        );
        return ConnectionEvent(e['deviceId'] as String, state);
      });

  Stream<BatteryLevelEvent> get batteryEvents => _rawEvents
      .where((e) => e['type'] == 'battery')
      .map((e) => BatteryLevelEvent(e['deviceId'], e['level']));

  Stream<HeartRateSample> get heartRateStream => _rawEvents
      .where((e) => e['type'] == 'hr')
      .map(
        (e) => HeartRateSample(
          hr: e['hr'],
          rrIntervalsMs: (e['rrs'] as List).cast<int>(),
          timestamp: DateTime.fromMillisecondsSinceEpoch(e['ts']),
        ),
      );

  Stream<EcgSampleBatch> get ecgStream => _rawEvents
      .where((e) => e['type'] == 'ecg')
      .map(
        (e) => EcgSampleBatch(
          samples: (e['samples'] as List).cast<int>(),
          samplingRate: e['samplingRate'],
          receivedAt: DateTime.fromMillisecondsSinceEpoch(e['ts']),
        ),
      );

  Future<void> initialize({bool enableEcg = true, bool enableHr = true}) async {
    await _method.invokeMethod('initialize', {
      'ecg': enableEcg,
      'hr': enableHr,
    });
  }

  /// Query whether the Bluetooth adapter is enabled on the device
  Future<bool> isBluetoothEnabled() async {
    try {
      final res = await _method.invokeMethod('isBluetoothEnabled');
      return res == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> connect(String deviceId) =>
      _method.invokeMethod('connect', {'deviceId': deviceId});
  Future<void> disconnect(String deviceId) =>
      _method.invokeMethod('disconnect', {'deviceId': deviceId});
  Future<void> startScan() => _method.invokeMethod('startScan');
  Future<void> stopScan() => _method.invokeMethod('stopScan');
  Future<void> startEcg(String deviceId) =>
      _method.invokeMethod('startEcg', {'deviceId': deviceId});
  Future<void> stopEcg(String deviceId) =>
      _method.invokeMethod('stopEcg', {'deviceId': deviceId});
}
