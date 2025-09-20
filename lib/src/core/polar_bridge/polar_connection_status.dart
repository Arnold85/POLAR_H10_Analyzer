/// Connection status enumeration for Polar device
enum PolarConnectionStatus {
  /// Device is disconnected
  disconnected,
  
  /// Attempting to connect to device
  connecting,
  
  /// Device is connected and ready
  connected,
  
  /// Device is streaming data
  streaming,
  
  /// Connection error occurred
  error,
  
  /// Device is scanning for devices
  scanning,
}

/// Extension for connection status display
extension PolarConnectionStatusExtension on PolarConnectionStatus {
  String get displayName {
    switch (this) {
      case PolarConnectionStatus.disconnected:
        return 'Disconnected';
      case PolarConnectionStatus.connecting:
        return 'Connecting';
      case PolarConnectionStatus.connected:
        return 'Connected';
      case PolarConnectionStatus.streaming:
        return 'Streaming';
      case PolarConnectionStatus.error:
        return 'Error';
      case PolarConnectionStatus.scanning:
        return 'Scanning';
    }
  }

  String get description {
    switch (this) {
      case PolarConnectionStatus.disconnected:
        return 'No device connected';
      case PolarConnectionStatus.connecting:
        return 'Establishing connection...';
      case PolarConnectionStatus.connected:
        return 'Device ready for use';
      case PolarConnectionStatus.streaming:
        return 'Receiving data stream';
      case PolarConnectionStatus.error:
        return 'Connection failed';
      case PolarConnectionStatus.scanning:
        return 'Searching for devices...';
    }
  }
}