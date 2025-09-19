import 'package:json_annotation/json_annotation.dart';

part 'heart_rate_sample.g.dart';

/// Domain model representing a heart rate sample
@JsonSerializable()
class HeartRateSample {
  /// Session this sample belongs to
  final String sessionId;
  
  /// Timestamp of the measurement
  final DateTime timestamp;
  
  /// Heart rate in beats per minute (BPM)
  final int heartRate;
  
  /// RR intervals in milliseconds (time between R-peaks)
  final List<int> rrIntervals;
  
  /// Contact status at time of measurement
  final bool contactDetected;
  
  /// Quality indicator (0-100)
  final int? quality;
  
  /// Source of the measurement
  final HeartRateSource source;

  const HeartRateSample({
    required this.sessionId,
    required this.timestamp,
    required this.heartRate,
    this.rrIntervals = const [],
    required this.contactDetected,
    this.quality,
    required this.source,
  });

  factory HeartRateSample.fromJson(Map<String, dynamic> json) =>
      _$HeartRateSampleFromJson(json);

  Map<String, dynamic> toJson() => _$HeartRateSampleToJson(this);

  HeartRateSample copyWith({
    String? sessionId,
    DateTime? timestamp,
    int? heartRate,
    List<int>? rrIntervals,
    bool? contactDetected,
    int? quality,
    HeartRateSource? source,
  }) {
    return HeartRateSample(
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      heartRate: heartRate ?? this.heartRate,
      rrIntervals: rrIntervals ?? this.rrIntervals,
      contactDetected: contactDetected ?? this.contactDetected,
      quality: quality ?? this.quality,
      source: source ?? this.source,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeartRateSample &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          timestamp == other.timestamp;

  @override
  int get hashCode => Object.hash(sessionId, timestamp);

  @override
  String toString() {
    return 'HeartRateSample{sessionId: $sessionId, heartRate: ${heartRate}bpm, rrIntervals: ${rrIntervals.length}, contact: $contactDetected}';
  }
}

/// Heart rate variability (HRV) sample with calculated metrics
@JsonSerializable()
class HrvSample {
  /// Session this sample belongs to
  final String sessionId;
  
  /// Timestamp of the calculation
  final DateTime timestamp;
  
  /// RR intervals used for calculation (in milliseconds)
  final List<int> rrIntervals;
  
  /// Time window for this calculation (in seconds)
  final int windowSeconds;
  
  /// RMSSD - Root Mean Square of Successive Differences (ms)
  final double? rmssd;
  
  /// SDNN - Standard Deviation of NN intervals (ms)
  final double? sdnn;
  
  /// pNN50 - Percentage of NN intervals > 50ms different from previous
  final double? pnn50;
  
  /// Average RR interval (ms)
  final double? meanRR;
  
  /// Heart rate calculated from RR intervals (BPM)
  final double? heartRate;
  
  /// Stress indicator (0-100, higher = more stressed)
  final int? stressIndex;

  const HrvSample({
    required this.sessionId,
    required this.timestamp,
    required this.rrIntervals,
    required this.windowSeconds,
    this.rmssd,
    this.sdnn,
    this.pnn50,
    this.meanRR,
    this.heartRate,
    this.stressIndex,
  });

  factory HrvSample.fromJson(Map<String, dynamic> json) =>
      _$HrvSampleFromJson(json);

  Map<String, dynamic> toJson() => _$HrvSampleToJson(this);

  @override
  String toString() {
    return 'HrvSample{sessionId: $sessionId, RMSSD: $rmssd, SDNN: $sdnn, pNN50: $pnn50, stress: $stressIndex}';
  }
}

/// Source of heart rate measurement
enum HeartRateSource {
  @JsonValue('ecg')
  ecg,
  @JsonValue('optical')
  optical,
  @JsonValue('chest_strap')
  chestStrap,
  @JsonValue('calculated')
  calculated,
}