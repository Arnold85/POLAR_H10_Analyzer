/// Polar device error types
enum PolarErrorType {
  /// Bluetooth is not enabled
  bluetoothDisabled,
  
  /// Location permission not granted
  locationPermissionDenied,
  
  /// Bluetooth permission not granted
  bluetoothPermissionDenied,
  
  /// Device not found during scan
  deviceNotFound,
  
  /// Connection timeout
  connectionTimeout,
  
  /// Device disconnected unexpectedly
  unexpectedDisconnection,
  
  /// Authentication failed
  authenticationFailed,
  
  /// Stream initialization failed
  streamInitializationFailed,
  
  /// Generic platform error
  platformError,
  
  /// Unknown error
  unknown,
}

/// Polar error class
class PolarError {
  const PolarError({
    required this.type,
    required this.message,
    this.details,
  });

  final PolarErrorType type;
  final String message;
  final String? details;

  @override
  String toString() {
    return 'PolarError(type: $type, message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PolarError &&
        other.type == type &&
        other.message == message &&
        other.details == details;
  }

  @override
  int get hashCode => Object.hash(type, message, details);
}

/// Extension for error type display
extension PolarErrorTypeExtension on PolarErrorType {
  String get displayName {
    switch (this) {
      case PolarErrorType.bluetoothDisabled:
        return 'Bluetooth Disabled';
      case PolarErrorType.locationPermissionDenied:
        return 'Location Permission Denied';
      case PolarErrorType.bluetoothPermissionDenied:
        return 'Bluetooth Permission Denied';
      case PolarErrorType.deviceNotFound:
        return 'Device Not Found';
      case PolarErrorType.connectionTimeout:
        return 'Connection Timeout';
      case PolarErrorType.unexpectedDisconnection:
        return 'Unexpected Disconnection';
      case PolarErrorType.authenticationFailed:
        return 'Authentication Failed';
      case PolarErrorType.streamInitializationFailed:
        return 'Stream Initialization Failed';
      case PolarErrorType.platformError:
        return 'Platform Error';
      case PolarErrorType.unknown:
        return 'Unknown Error';
    }
  }
}