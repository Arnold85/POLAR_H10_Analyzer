import 'dart:async';
import 'ble_service.dart';
import '../../domain/models/heart_rate_sample.dart';
import '../../domain/models/ecg_sample.dart';
import '../../domain/models/polar_device.dart';
import '../../domain/models/connection_event.dart';

class MockBleService implements BleService {
  final _connectionController = StreamController<ConnectionEvent>.broadcast();
  final _hrController = StreamController<HeartRateSample>.broadcast();
  final _ecgController = StreamController<EcgSampleBatch>.broadcast();
  final _scanController = StreamController<PolarDevice>.broadcast();

  Timer? _hrTimer;
  Timer? _scanTimer;

  MockBleService() {
    // Emit a fake device every 2 seconds
    _scanTimer = Timer.periodic(Duration(seconds: 2), (t) {
      _scanController.add(
        PolarDevice(
          deviceId: 'MOCK_1234',
          name: 'Polar H10 (Mock)',
          firmwareVersion: '0.0.1',
          batteryLevel: 90,
          connectionStatus: DeviceConnectionStatus.disconnected,
          signalQuality: 100,
          electrodeStatus: ElectrodeStatus.excellent,
          lastSeen: DateTime.now(),
        ),
      );
    });
  }

  @override
  Stream<ConnectionEvent> get connectionEvents => _connectionController.stream;

  @override
  Stream<HeartRateSample> get heartRateStream => _hrController.stream;

  @override
  Stream<EcgSampleBatch> get ecgStream => _ecgController.stream;

  @override
  Stream<PolarDevice> get scanResults => _scanController.stream;

  @override
  Future<void> connect(String deviceId) async {
    _connectionController.add(
      ConnectionEvent(deviceId, DeviceConnectionStatus.connecting),
    );
    await Future.delayed(Duration(seconds: 1));
    _connectionController.add(
      ConnectionEvent(deviceId, DeviceConnectionStatus.connected),
    );
    // start HR emission
    _hrTimer = Timer.periodic(Duration(seconds: 1), (t) {
      final ts = DateTime.now();
      _hrController.add(
        HeartRateSample(
          sessionId: 'mock-session',
          timestamp: ts,
          heartRate: 60 + (t.tick % 20),
          rrIntervals: [800, 820, 790],
          contactDetected: true,
          source: HeartRateSource.chestStrap,
        ),
      );
    });
  }

  @override
  Future<void> disconnect(String deviceId) async {
    _hrTimer?.cancel();
    _connectionController.add(
      ConnectionEvent(deviceId, DeviceConnectionStatus.disconnected),
    );
  }

  @override
  Future<void> initialize({bool enableEcg = true, bool enableHr = true}) async {
    // no-op for mock
  }

  @override
  Future<void> startScan() async {
    // already scanning in constructor
  }

  @override
  Future<void> stopScan() async {
    _scanTimer?.cancel();
  }
}
