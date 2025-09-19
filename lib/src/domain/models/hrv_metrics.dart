/// Heart Rate Variability (HRV) metrics model
/// 
/// Contains the core HRV measurements as defined in the development plan:
/// - RMSSD: Root Mean Square of Successive Differences
/// - SDNN: Standard Deviation of NN intervals
/// - pNN50: Percentage of NN intervals differing by more than 50ms
class HrvMetrics {
  const HrvMetrics({
    required this.rmssd,
    required this.sdnn,
    required this.pnn50,
    required this.calculatedAt,
    this.meanRr,
    this.totalBeats,
    this.measurementDurationMs,
  });

  /// Root Mean Square of Successive Differences (ms)
  /// Reflects parasympathetic nervous system activity
  final double rmssd;

  /// Standard Deviation of NN intervals (ms)
  /// Overall HRV measure reflecting both sympathetic and parasympathetic activity
  final double sdnn;

  /// Percentage of NN intervals differing by more than 50ms (%)
  /// Reflects parasympathetic activity
  final double pnn50;

  /// When these metrics were calculated
  final DateTime calculatedAt;

  /// Mean RR interval (ms) - optional
  final double? meanRr;

  /// Total number of beats analyzed - optional
  final int? totalBeats;

  /// Duration of measurement period in milliseconds - optional
  final int? measurementDurationMs;

  @override
  String toString() {
    return 'HrvMetrics(rmssd: $rmssd, sdnn: $sdnn, pnn50: $pnn50, calculatedAt: $calculatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HrvMetrics &&
        other.rmssd == rmssd &&
        other.sdnn == sdnn &&
        other.pnn50 == pnn50 &&
        other.calculatedAt == calculatedAt &&
        other.meanRr == meanRr &&
        other.totalBeats == totalBeats &&
        other.measurementDurationMs == measurementDurationMs;
  }

  @override
  int get hashCode {
    return Object.hash(
      rmssd,
      sdnn,
      pnn50,
      calculatedAt,
      meanRr,
      totalBeats,
      measurementDurationMs,
    );
  }
}