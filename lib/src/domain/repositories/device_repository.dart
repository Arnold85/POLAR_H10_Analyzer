import '../models/polar_device.dart';

/// Repository interface for Polar device management
abstract class DeviceRepository {
  /// Get all known devices
  Future<List<PolarDevice>> getDevices();
  
  /// Get device by ID
  Future<PolarDevice?> getDevice(String deviceId);
  
  /// Save or update device
  Future<void> saveDevice(PolarDevice device);
  
  /// Delete device
  Future<void> deleteDevice(String deviceId);
  
  /// Update device connection status
  Future<void> updateConnectionStatus(
    String deviceId, 
    DeviceConnectionStatus status,
  );
  
  /// Update device signal quality
  Future<void> updateSignalQuality(String deviceId, int quality);
  
  /// Update electrode status
  Future<void> updateElectrodeStatus(
    String deviceId, 
    ElectrodeStatus status,
  );
}