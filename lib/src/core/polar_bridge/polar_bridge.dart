import 'dart:async';

import 'package:flutter/services.dart';

import 'polar_connection_status.dart';
import 'polar_data_models.dart';
import 'polar_device.dart';
import 'polar_error.dart';

/// Flutter plugin for Polar BLE SDK integration
class PolarBridge {
  static const MethodChannel _methodChannel =
      MethodChannel('polar_bridge/methods');
  
  static const EventChannel _connectionStatusChannel =
      EventChannel('polar_bridge/connection_status');
      
  static const EventChannel _heartRateChannel =
      EventChannel('polar_bridge/heart_rate');
      
  static const EventChannel _ecgChannel =
      EventChannel('polar_bridge/ecg');
      
  static const EventChannel _accelerationChannel =
      EventChannel('polar_bridge/acceleration');
      
  static const EventChannel _deviceDiscoveryChannel =
      EventChannel('polar_bridge/device_discovery');

  static PolarBridge? _instance;
  
  PolarBridge._();
  
  /// Singleton instance
  static PolarBridge get instance {
    _instance ??= PolarBridge._();
    return _instance!;
  }

  /// Initialize the plugin
  Future<void> initialize() async {
    try {
      await _methodChannel.invokeMethod('initialize');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Check if Bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('isBluetoothEnabled');
      return result ?? false;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Request Bluetooth permissions
  Future<bool> requestBluetoothPermissions() async {
    try {
      final result = await _methodChannel.invokeMethod<bool>('requestBluetoothPermissions');
      return result ?? false;
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Start scanning for Polar devices
  Future<void> startDeviceScan() async {
    try {
      await _methodChannel.invokeMethod('startDeviceScan');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Stop scanning for devices
  Future<void> stopDeviceScan() async {
    try {
      await _methodChannel.invokeMethod('stopDeviceScan');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Connect to a Polar device
  Future<void> connectToDevice(String deviceId) async {
    try {
      await _methodChannel.invokeMethod('connectToDevice', {'deviceId': deviceId});
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Disconnect from the current device
  Future<void> disconnectFromDevice() async {
    try {
      await _methodChannel.invokeMethod('disconnectFromDevice');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Start heart rate streaming
  Future<void> startHeartRateStream() async {
    try {
      await _methodChannel.invokeMethod('startHeartRateStream');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Stop heart rate streaming
  Future<void> stopHeartRateStream() async {
    try {
      await _methodChannel.invokeMethod('stopHeartRateStream');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Start ECG streaming
  Future<void> startEcgStream() async {
    try {
      await _methodChannel.invokeMethod('startEcgStream');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Stop ECG streaming
  Future<void> stopEcgStream() async {
    try {
      await _methodChannel.invokeMethod('stopEcgStream');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Start acceleration streaming
  Future<void> startAccelerationStream() async {
    try {
      await _methodChannel.invokeMethod('startAccelerationStream');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Stop acceleration streaming
  Future<void> stopAccelerationStream() async {
    try {
      await _methodChannel.invokeMethod('stopAccelerationStream');
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Stream of connection status updates
  Stream<PolarConnectionStatus> get connectionStatusStream {
    return _connectionStatusChannel.receiveBroadcastStream().map((event) {
      final statusString = event as String;
      return PolarConnectionStatus.values.firstWhere(
        (status) => status.name == statusString,
        orElse: () => PolarConnectionStatus.disconnected,
      );
    });
  }

  /// Stream of discovered devices
  Stream<PolarDevice> get deviceDiscoveryStream {
    return _deviceDiscoveryChannel.receiveBroadcastStream().map((event) {
      final deviceMap = Map<String, dynamic>.from(event as Map);
      return PolarDevice.fromJson(deviceMap);
    });
  }

  /// Stream of heart rate samples
  Stream<HeartRateSample> get heartRateStream {
    return _heartRateChannel.receiveBroadcastStream().map((event) {
      final sampleMap = Map<String, dynamic>.from(event as Map);
      return HeartRateSample.fromJson(sampleMap);
    });
  }

  /// Stream of ECG samples
  Stream<EcgSample> get ecgStream {
    return _ecgChannel.receiveBroadcastStream().map((event) {
      final sampleMap = Map<String, dynamic>.from(event as Map);
      return EcgSample.fromJson(sampleMap);
    });
  }

  /// Stream of acceleration samples
  Stream<AccelerationSample> get accelerationStream {
    return _accelerationChannel.receiveBroadcastStream().map((event) {
      final sampleMap = Map<String, dynamic>.from(event as Map);
      return AccelerationSample.fromJson(sampleMap);
    });
  }

  /// Enable mock mode for testing
  Future<void> enableMockMode({bool enabled = true}) async {
    try {
      await _methodChannel.invokeMethod('enableMockMode', {'enabled': enabled});
    } on PlatformException catch (e) {
      throw _handlePlatformException(e);
    }
  }

  /// Handle platform exceptions and convert to PolarError
  PolarError _handlePlatformException(PlatformException e) {
    PolarErrorType errorType;
    
    switch (e.code) {
      case 'BLUETOOTH_DISABLED':
        errorType = PolarErrorType.bluetoothDisabled;
        break;
      case 'LOCATION_PERMISSION_DENIED':
        errorType = PolarErrorType.locationPermissionDenied;
        break;
      case 'BLUETOOTH_PERMISSION_DENIED':
        errorType = PolarErrorType.bluetoothPermissionDenied;
        break;
      case 'DEVICE_NOT_FOUND':
        errorType = PolarErrorType.deviceNotFound;
        break;
      case 'CONNECTION_TIMEOUT':
        errorType = PolarErrorType.connectionTimeout;
        break;
      case 'UNEXPECTED_DISCONNECTION':
        errorType = PolarErrorType.unexpectedDisconnection;
        break;
      case 'AUTHENTICATION_FAILED':
        errorType = PolarErrorType.authenticationFailed;
        break;
      case 'STREAM_INITIALIZATION_FAILED':
        errorType = PolarErrorType.streamInitializationFailed;
        break;
      case 'PLATFORM_ERROR':
        errorType = PolarErrorType.platformError;
        break;
      default:
        errorType = PolarErrorType.unknown;
    }
    
    return PolarError(
      type: errorType,
      message: e.message ?? 'Unknown error occurred',
      details: e.details?.toString(),
    );
  }
}