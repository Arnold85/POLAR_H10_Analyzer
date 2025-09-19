/// Represents a Polar device
class PolarDevice {
  const PolarDevice({
    required this.deviceId,
    required this.name,
    required this.address,
    this.rssi,
    this.isConnectable = true,
  });

  /// Unique device identifier
  final String deviceId;
  
  /// Device name (e.g., "Polar H10 12345678")
  final String name;
  
  /// Bluetooth MAC address
  final String address;
  
  /// Signal strength (Received Signal Strength Indicator)
  final int? rssi;
  
  /// Whether the device can be connected to
  final bool isConnectable;

  /// Create a copy with updated values
  PolarDevice copyWith({
    String? deviceId,
    String? name,
    String? address,
    int? rssi,
    bool? isConnectable,
  }) {
    return PolarDevice(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      address: address ?? this.address,
      rssi: rssi ?? this.rssi,
      isConnectable: isConnectable ?? this.isConnectable,
    );
  }

  /// Create from JSON map
  factory PolarDevice.fromJson(Map<String, dynamic> json) {
    return PolarDevice(
      deviceId: json['deviceId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      rssi: json['rssi'] as int?,
      isConnectable: json['isConnectable'] as bool? ?? true,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'name': name,
      'address': address,
      'rssi': rssi,
      'isConnectable': isConnectable,
    };
  }

  @override
  String toString() {
    return 'PolarDevice(deviceId: $deviceId, name: $name, address: $address, rssi: $rssi, isConnectable: $isConnectable)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PolarDevice &&
        other.deviceId == deviceId &&
        other.name == name &&
        other.address == address &&
        other.rssi == rssi &&
        other.isConnectable == isConnectable;
  }

  @override
  int get hashCode {
    return Object.hash(deviceId, name, address, rssi, isConnectable);
  }
}