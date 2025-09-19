/// Abstract interface for signal processing operations
/// 
/// Provides the foundation for ECG signal processing, filtering,
/// and artifact detection as specified in the development plan
abstract class SignalProcessor {
  /// Apply filtering to raw ECG signal data
  /// 
  /// [rawSignal] Raw ECG samples from the Polar H10 sensor
  /// [samplingRate] Sampling rate in Hz (typically 130Hz for Polar H10)
  /// Returns filtered signal ready for further processing
  Future<List<double>> applyFiltering(
    List<double> rawSignal,
    int samplingRate,
  );

  /// Detect and remove artifacts from the signal
  /// 
  /// [signal] Input signal data
  /// [samplingRate] Sampling rate in Hz
  /// Returns signal with artifacts marked or removed
  Future<ArtifactDetectionResult> detectArtifacts(
    List<double> signal,
    int samplingRate,
  );

  /// Detect R-peaks in the ECG signal
  /// 
  /// [signal] Filtered ECG signal
  /// [samplingRate] Sampling rate in Hz
  /// Returns list of R-peak timestamps and quality metrics
  Future<RPeakDetectionResult> detectRPeaks(
    List<double> signal,
    int samplingRate,
  );

  /// Extract time-domain features from the signal
  /// 
  /// [rrIntervals] RR intervals in milliseconds
  /// Returns time-domain analysis features
  Future<TimeDomainFeatures> extractTimeDomainFeatures(
    List<double> rrIntervals,
  );

  /// Extract frequency-domain features from the signal
  /// 
  /// [rrIntervals] RR intervals in milliseconds
  /// [samplingRate] Effective sampling rate for RR intervals
  /// Returns frequency-domain analysis features
  Future<FrequencyDomainFeatures> extractFrequencyDomainFeatures(
    List<double> rrIntervals,
    double samplingRate,
  );
}

/// Result of artifact detection process
class ArtifactDetectionResult {
  const ArtifactDetectionResult({
    required this.cleanedSignal,
    required this.artifactIndices,
    required this.qualityScore,
  });

  /// Signal with artifacts handled (removed or corrected)
  final List<double> cleanedSignal;

  /// Indices in original signal where artifacts were detected
  final List<int> artifactIndices;

  /// Overall signal quality score (0.0-1.0)
  final double qualityScore;
}

/// Result of R-peak detection process
class RPeakDetectionResult {
  const RPeakDetectionResult({
    required this.peakIndices,
    required this.rrIntervals,
    required this.confidence,
    this.heartRate,
  });

  /// Indices of detected R-peaks in the signal
  final List<int> peakIndices;

  /// RR intervals between consecutive peaks (in milliseconds)
  final List<double> rrIntervals;

  /// Confidence scores for each detected peak (0.0-1.0)
  final List<double> confidence;

  /// Instantaneous heart rate values (bpm) - optional
  final List<double>? heartRate;
}

/// Time-domain features extracted from HRV analysis
class TimeDomainFeatures {
  const TimeDomainFeatures({
    required this.mean,
    required this.std,
    required this.rmssd,
    required this.pnn50,
    this.pnn20,
    this.triangularIndex,
    this.tinn,
  });

  /// Mean of RR intervals (ms)
  final double mean;

  /// Standard deviation of RR intervals (ms)
  final double std;

  /// RMSSD - Root mean square of successive differences (ms)
  final double rmssd;

  /// pNN50 - Percentage of successive RR intervals differing by >50ms
  final double pnn50;

  /// pNN20 - Percentage of successive RR intervals differing by >20ms - optional
  final double? pnn20;

  /// Triangular index - optional
  final double? triangularIndex;

  /// TINN - Triangular interpolation of RR intervals - optional
  final double? tinn;
}

/// Frequency-domain features extracted from HRV analysis
class FrequencyDomainFeatures {
  const FrequencyDomainFeatures({
    required this.totalPower,
    required this.vlfPower,
    required this.lfPower,
    required this.hfPower,
    required this.lfHfRatio,
    this.normalizedLf,
    this.normalizedHf,
  });

  /// Total power in the frequency spectrum (ms²)
  final double totalPower;

  /// Very Low Frequency power (0.0033-0.04 Hz) (ms²)
  final double vlfPower;

  /// Low Frequency power (0.04-0.15 Hz) (ms²)
  final double lfPower;

  /// High Frequency power (0.15-0.4 Hz) (ms²)
  final double hfPower;

  /// LF/HF ratio - sympathovagal balance indicator
  final double lfHfRatio;

  /// Normalized LF power (LF/(Total-VLF)) - optional
  final double? normalizedLf;

  /// Normalized HF power (HF/(Total-VLF)) - optional
  final double? normalizedHf;
}