/// Heart rate analysis model
/// 
/// Contains resting and maximum heart rate analysis as specified in the development plan
class HeartRateAnalysis {
  const HeartRateAnalysis({
    required this.restingHeartRate,
    required this.maxHeartRate,
    required this.currentHeartRate,
    required this.analyzedAt,
    this.minHeartRate,
    this.averageHeartRate,
    this.heartRateZone,
  });

  /// Resting heart rate (bpm)
  final int restingHeartRate;

  /// Maximum heart rate (bpm)
  final int maxHeartRate;

  /// Current heart rate (bpm)
  final int currentHeartRate;

  /// When this analysis was performed
  final DateTime analyzedAt;

  /// Minimum heart rate recorded in session (bpm) - optional
  final int? minHeartRate;

  /// Average heart rate for session (bpm) - optional
  final double? averageHeartRate;

  /// Current heart rate zone - optional
  final HeartRateZone? heartRateZone;

  /// Calculate heart rate reserve (HRR)
  int get heartRateReserve => maxHeartRate - restingHeartRate;

  /// Calculate percentage of heart rate reserve for current HR
  double get percentageHrr => 
      ((currentHeartRate - restingHeartRate) / heartRateReserve) * 100;

  @override
  String toString() {
    return 'HeartRateAnalysis(resting: $restingHeartRate, max: $maxHeartRate, current: $currentHeartRate, analyzedAt: $analyzedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HeartRateAnalysis &&
        other.restingHeartRate == restingHeartRate &&
        other.maxHeartRate == maxHeartRate &&
        other.currentHeartRate == currentHeartRate &&
        other.analyzedAt == analyzedAt &&
        other.minHeartRate == minHeartRate &&
        other.averageHeartRate == averageHeartRate &&
        other.heartRateZone == heartRateZone;
  }

  @override
  int get hashCode {
    return Object.hash(
      restingHeartRate,
      maxHeartRate,
      currentHeartRate,
      analyzedAt,
      minHeartRate,
      averageHeartRate,
      heartRateZone,
    );
  }
}

/// Heart rate training zones
enum HeartRateZone {
  zone1, // 50-60% HRR - Active Recovery
  zone2, // 60-70% HRR - Aerobic Base
  zone3, // 70-80% HRR - Aerobic
  zone4, // 80-90% HRR - Lactate Threshold
  zone5, // 90-100% HRR - Neuromuscular Power
}

extension HeartRateZoneExtension on HeartRateZone {
  String get name {
    switch (this) {
      case HeartRateZone.zone1:
        return 'Zone 1 - Active Recovery';
      case HeartRateZone.zone2:
        return 'Zone 2 - Aerobic Base';
      case HeartRateZone.zone3:
        return 'Zone 3 - Aerobic';
      case HeartRateZone.zone4:
        return 'Zone 4 - Lactate Threshold';
      case HeartRateZone.zone5:
        return 'Zone 5 - Neuromuscular Power';
    }
  }

  String get description {
    switch (this) {
      case HeartRateZone.zone1:
        return '50-60% HRR - Recovery and warm-up';
      case HeartRateZone.zone2:
        return '60-70% HRR - Fat burning and base building';
      case HeartRateZone.zone3:
        return '70-80% HRR - Aerobic development';
      case HeartRateZone.zone4:
        return '80-90% HRR - Lactate threshold training';
      case HeartRateZone.zone5:
        return '90-100% HRR - Maximum effort training';
    }
  }
}