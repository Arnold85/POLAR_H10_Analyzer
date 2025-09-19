import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/domain/models/polar_device.dart';

void main() {
  group('PolarDevice', () {
    test('should create a valid PolarDevice instance', () {
      final device = PolarDevice(
        deviceId: 'DEVICE123',
        name: 'Polar H10',
        connectionStatus: DeviceConnectionStatus.connected,
        electrodeStatus: ElectrodeStatus.good,
        lastSeen: DateTime.now(),
      );

      expect(device.deviceId, 'DEVICE123');
      expect(device.name, 'Polar H10');
      expect(device.connectionStatus, DeviceConnectionStatus.connected);
      expect(device.electrodeStatus, ElectrodeStatus.good);
    });

    test('should support copyWith functionality', () {
      final originalDevice = PolarDevice(
        deviceId: 'DEVICE123',
        name: 'Polar H10',
        connectionStatus: DeviceConnectionStatus.disconnected,
        electrodeStatus: ElectrodeStatus.poor,
        lastSeen: DateTime.now(),
      );

      final updatedDevice = originalDevice.copyWith(
        connectionStatus: DeviceConnectionStatus.connected,
        electrodeStatus: ElectrodeStatus.excellent,
        batteryLevel: 85,
      );

      expect(updatedDevice.deviceId, originalDevice.deviceId);
      expect(updatedDevice.name, originalDevice.name);
      expect(updatedDevice.connectionStatus, DeviceConnectionStatus.connected);
      expect(updatedDevice.electrodeStatus, ElectrodeStatus.excellent);
      expect(updatedDevice.batteryLevel, 85);
    });

    test('should implement equality correctly', () {
      final device1 = PolarDevice(
        deviceId: 'DEVICE123',
        name: 'Polar H10',
        connectionStatus: DeviceConnectionStatus.connected,
        electrodeStatus: ElectrodeStatus.good,
        lastSeen: DateTime.now(),
      );

      final device2 = PolarDevice(
        deviceId: 'DEVICE123',
        name: 'Different Name',
        connectionStatus: DeviceConnectionStatus.disconnected,
        electrodeStatus: ElectrodeStatus.poor,
        lastSeen: DateTime.now(),
      );

      final device3 = PolarDevice(
        deviceId: 'DIFFERENT456',
        name: 'Polar H10',
        connectionStatus: DeviceConnectionStatus.connected,
        electrodeStatus: ElectrodeStatus.good,
        lastSeen: DateTime.now(),
      );

      expect(device1, equals(device2)); // Same deviceId
      expect(device1, isNot(equals(device3))); // Different deviceId
    });

    test('should handle JSON serialization', () {
      final device = PolarDevice(
        deviceId: 'DEVICE123',
        name: 'Polar H10',
        firmwareVersion: '1.2.3',
        batteryLevel: 85,
        connectionStatus: DeviceConnectionStatus.connected,
        signalQuality: 95,
        electrodeStatus: ElectrodeStatus.excellent,
        lastSeen: DateTime.parse('2023-01-01T12:00:00Z'),
      );

      final json = device.toJson();
      expect(json['deviceId'], 'DEVICE123');
      expect(json['name'], 'Polar H10');
      expect(json['connectionStatus'], 'connected');
      expect(json['electrodeStatus'], 'excellent');

      final deviceFromJson = PolarDevice.fromJson(json);
      expect(deviceFromJson.deviceId, device.deviceId);
      expect(deviceFromJson.connectionStatus, device.connectionStatus);
    });
  });

  group('DeviceConnectionStatus', () {
    test('should have correct string values', () {
      expect(DeviceConnectionStatus.disconnected.name, 'disconnected');
      expect(DeviceConnectionStatus.connecting.name, 'connecting');
      expect(DeviceConnectionStatus.connected.name, 'connected');
      expect(DeviceConnectionStatus.error.name, 'error');
    });
  });

  group('ElectrodeStatus', () {
    test('should have correct string values', () {
      expect(ElectrodeStatus.unknown.name, 'unknown');
      expect(ElectrodeStatus.poor.name, 'poor');
      expect(ElectrodeStatus.good.name, 'good');
      expect(ElectrodeStatus.excellent.name, 'excellent');
    });
  });
}