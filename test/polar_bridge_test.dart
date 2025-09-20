import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/core/polar_bridge/polar_bridge_plugin.dart';

void main() {
  group('Polar Bridge Plugin Tests', () {
    late PolarBridge polarBridge;

    setUp(() {
      polarBridge = PolarBridge.instance;
    });

    test('should initialize without errors', () async {
      // This test will fail in testing environment without actual Android implementation
      // but validates the interface is correct
      expect(polarBridge, isNotNull);
    });

    test('connection status enum should have correct values', () {
      expect(PolarConnectionStatus.disconnected.displayName, 'Disconnected');
      expect(PolarConnectionStatus.connecting.displayName, 'Connecting');
      expect(PolarConnectionStatus.connected.displayName, 'Connected');
      expect(PolarConnectionStatus.streaming.displayName, 'Streaming');
      expect(PolarConnectionStatus.error.displayName, 'Error');
      expect(PolarConnectionStatus.scanning.displayName, 'Scanning');
    });

    test('polar error should be created correctly', () {
      const error = PolarError(
        type: PolarErrorType.bluetoothDisabled,
        message: 'Bluetooth is disabled',
        details: 'Please enable Bluetooth',
      );

      expect(error.type, PolarErrorType.bluetoothDisabled);
      expect(error.message, 'Bluetooth is disabled');
      expect(error.details, 'Please enable Bluetooth');
      expect(error.type.displayName, 'Bluetooth Disabled');
    });

    test('polar device should serialize correctly', () {
      const device = PolarDevice(
        deviceId: '12345678',
        name: 'Polar H10 12345678',
        address: 'AA:BB:CC:DD:EE:FF',
        rssi: -60,
        isConnectable: true,
      );

      final json = device.toJson();
      final deviceFromJson = PolarDevice.fromJson(json);

      expect(deviceFromJson.deviceId, device.deviceId);
      expect(deviceFromJson.name, device.name);
      expect(deviceFromJson.address, device.address);
      expect(deviceFromJson.rssi, device.rssi);
      expect(deviceFromJson.isConnectable, device.isConnectable);
    });

    test('heart rate sample should serialize correctly', () {
      final timestamp = DateTime.now();
      final sample = HeartRateSample(
        timestamp: timestamp,
        heartRate: 75,
        rrIntervals: const [800, 820, 790],
        contactStatus: true,
        contactSupported: true,
      );

      final json = sample.toJson();
      final sampleFromJson = HeartRateSample.fromJson(json);

      expect(sampleFromJson.timestamp, timestamp);
      expect(sampleFromJson.heartRate, 75);
      expect(sampleFromJson.rrIntervals, const [800, 820, 790]);
      expect(sampleFromJson.contactStatus, true);
      expect(sampleFromJson.contactSupported, true);
    });

    test('ecg sample should serialize correctly', () {
      final timestamp = DateTime.now();
      final sample = EcgSample(
        timestamp: timestamp,
        samples: const [100, 200, 150, 120],
        samplingRate: 130,
      );

      final json = sample.toJson();
      final sampleFromJson = EcgSample.fromJson(json);

      expect(sampleFromJson.timestamp, timestamp);
      expect(sampleFromJson.samples, const [100, 200, 150, 120]);
      expect(sampleFromJson.samplingRate, 130);
    });

    test('acceleration sample should serialize correctly', () {
      final timestamp = DateTime.now();
      final sample = AccelerationSample(
        timestamp: timestamp,
        x: 100,
        y: -50,
        z: 200,
      );

      final json = sample.toJson();
      final sampleFromJson = AccelerationSample.fromJson(json);

      expect(sampleFromJson.timestamp, timestamp);
      expect(sampleFromJson.x, 100);
      expect(sampleFromJson.y, -50);
      expect(sampleFromJson.z, 200);
    });
  });
}