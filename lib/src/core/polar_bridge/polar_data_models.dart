/// Heart rate sample data
class HeartRateSample {
  const HeartRateSample({
    required this.timestamp,
    required this.heartRate,
    this.rrIntervals = const [],
    this.contactStatus,
    this.contactSupported,
  });

  /// Timestamp when the sample was taken
  final DateTime timestamp;
  
  /// Heart rate in beats per minute
  final int heartRate;
  
  /// RR intervals in milliseconds
  final List<int> rrIntervals;
  
  /// Contact status (true if sensor is in contact with skin)
  final bool? contactStatus;
  
  /// Whether contact detection is supported
  final bool? contactSupported;

  /// Create from JSON map
  factory HeartRateSample.fromJson(Map<String, dynamic> json) {
    return HeartRateSample(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      heartRate: json['heartRate'] as int,
      rrIntervals: (json['rrIntervals'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList() ?? const [],
      contactStatus: json['contactStatus'] as bool?,
      contactSupported: json['contactSupported'] as bool?,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'heartRate': heartRate,
      'rrIntervals': rrIntervals,
      'contactStatus': contactStatus,
      'contactSupported': contactSupported,
    };
  }

  @override
  String toString() {
    return 'HeartRateSample(timestamp: $timestamp, heartRate: $heartRate, rrIntervals: $rrIntervals, contactStatus: $contactStatus)';
  }
}

/// ECG sample data
class EcgSample {
  const EcgSample({
    required this.timestamp,
    required this.samples,
    required this.samplingRate,
  });

  /// Timestamp when the sample was taken
  final DateTime timestamp;
  
  /// ECG voltage samples in microvolts
  final List<int> samples;
  
  /// Sampling rate in Hz
  final int samplingRate;

  /// Create from JSON map
  factory EcgSample.fromJson(Map<String, dynamic> json) {
    return EcgSample(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      samples: (json['samples'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      samplingRate: json['samplingRate'] as int,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'samples': samples,
      'samplingRate': samplingRate,
    };
  }

  @override
  String toString() {
    return 'EcgSample(timestamp: $timestamp, samples: ${samples.length} samples, samplingRate: $samplingRate Hz)';
  }
}

/// Acceleration sample data
class AccelerationSample {
  const AccelerationSample({
    required this.timestamp,
    required this.x,
    required this.y,
    required this.z,
  });

  /// Timestamp when the sample was taken
  final DateTime timestamp;
  
  /// X-axis acceleration in mg
  final int x;
  
  /// Y-axis acceleration in mg
  final int y;
  
  /// Z-axis acceleration in mg
  final int z;

  /// Create from JSON map
  factory AccelerationSample.fromJson(Map<String, dynamic> json) {
    return AccelerationSample(
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      x: json['x'] as int,
      y: json['y'] as int,
      z: json['z'] as int,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'x': x,
      'y': y,
      'z': z,
    };
  }

  @override
  String toString() {
    return 'AccelerationSample(timestamp: $timestamp, x: $x, y: $y, z: $z)';
  }
}