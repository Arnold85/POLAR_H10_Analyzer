/// Stress indicator model
/// 
/// Contains stress analysis including sympathetic/parasympathetic balance
/// as specified in the development plan
class StressIndicator {
  const StressIndicator({
    required this.stressLevel,
    required this.sympatheticActivity,
    required this.parasympatheticActivity,
    required this.balanceRatio,
    required this.calculatedAt,
    this.confidence,
    this.trends,
  });

  /// Overall stress level (0.0 = very low stress, 1.0 = very high stress)
  final double stressLevel;

  /// Sympathetic nervous system activity indicator (0.0-1.0)
  final double sympatheticActivity;

  /// Parasympathetic nervous system activity indicator (0.0-1.0)
  final double parasympatheticActivity;

  /// Sympathetic/Parasympathetic balance ratio
  /// Values > 1.0 indicate sympathetic dominance (stress)
  /// Values < 1.0 indicate parasympathetic dominance (recovery)
  final double balanceRatio;

  /// When this stress analysis was calculated
  final DateTime calculatedAt;

  /// Confidence level of the stress assessment (0.0-1.0) - optional
  final double? confidence;

  /// Stress trend over time - optional
  final StressTrend? trends;

  /// Get stress level category
  StressLevel get stressCategory {
    if (stressLevel <= 0.2) return StressLevel.veryLow;
    if (stressLevel <= 0.4) return StressLevel.low;
    if (stressLevel <= 0.6) return StressLevel.moderate;
    if (stressLevel <= 0.8) return StressLevel.high;
    return StressLevel.veryHigh;
  }

  /// Get autonomic nervous system balance description
  String get balanceDescription {
    if (balanceRatio > 1.5) return 'High sympathetic dominance';
    if (balanceRatio > 1.2) return 'Moderate sympathetic dominance';
    if (balanceRatio > 0.8) return 'Balanced autonomic state';
    if (balanceRatio > 0.5) return 'Moderate parasympathetic dominance';
    return 'High parasympathetic dominance';
  }

  @override
  String toString() {
    return 'StressIndicator(level: $stressLevel, balance: $balanceRatio, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StressIndicator &&
        other.stressLevel == stressLevel &&
        other.sympatheticActivity == sympatheticActivity &&
        other.parasympatheticActivity == parasympatheticActivity &&
        other.balanceRatio == balanceRatio &&
        other.calculatedAt == calculatedAt &&
        other.confidence == confidence &&
        other.trends == trends;
  }

  @override
  int get hashCode {
    return Object.hash(
      stressLevel,
      sympatheticActivity,
      parasympatheticActivity,
      balanceRatio,
      calculatedAt,
      confidence,
      trends,
    );
  }
}

/// Stress level categories
enum StressLevel {
  veryLow,
  low,
  moderate,
  high,
  veryHigh,
}

extension StressLevelExtension on StressLevel {
  String get name {
    switch (this) {
      case StressLevel.veryLow:
        return 'Very Low';
      case StressLevel.low:
        return 'Low';
      case StressLevel.moderate:
        return 'Moderate';
      case StressLevel.high:
        return 'High';
      case StressLevel.veryHigh:
        return 'Very High';
    }
  }

  String get description {
    switch (this) {
      case StressLevel.veryLow:
        return 'Excellent recovery state';
      case StressLevel.low:
        return 'Good recovery state';
      case StressLevel.moderate:
        return 'Moderate stress level';
      case StressLevel.high:
        return 'Elevated stress level';
      case StressLevel.veryHigh:
        return 'Very high stress level';
    }
  }
}

/// Stress trend information
class StressTrend {
  const StressTrend({
    required this.direction,
    required this.magnitude,
    required this.timeWindow,
  });

  /// Direction of stress trend
  final TrendDirection direction;

  /// Magnitude of change (0.0-1.0)
  final double magnitude;

  /// Time window for trend analysis
  final Duration timeWindow;

  @override
  String toString() {
    return 'StressTrend(direction: $direction, magnitude: $magnitude, timeWindow: $timeWindow)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StressTrend &&
        other.direction == direction &&
        other.magnitude == magnitude &&
        other.timeWindow == timeWindow;
  }

  @override
  int get hashCode {
    return Object.hash(direction, magnitude, timeWindow);
  }
}

/// Trend direction
enum TrendDirection {
  increasing,
  decreasing,
  stable,
}