import '../models/hrv_metrics.dart';
import '../models/heart_rate_analysis.dart';
import '../models/stress_indicator.dart';
import 'validation_interfaces.dart';

/// Abstract interface for HRV (Heart Rate Variability) calculations
///
/// Implements the statistical basis calculations as specified in the development plan
abstract class HrvCalculator {
  /// Calculate HRV metrics from RR intervals
  ///
  /// [rrIntervals] RR intervals in milliseconds
  /// [windowSize] Analysis window size in milliseconds (optional)
  /// Returns calculated HRV metrics
  Future<HrvMetrics> calculateHrvMetrics(
    List<double> rrIntervals, {
    int? windowSize,
  });

  /// Calculate RMSSD (Root Mean Square of Successive Differences)
  ///
  /// [rrIntervals] RR intervals in milliseconds
  /// Returns RMSSD value in milliseconds
  double calculateRmssd(List<double> rrIntervals);

  /// Calculate SDNN (Standard Deviation of NN intervals)
  ///
  /// [rrIntervals] RR intervals in milliseconds
  /// Returns SDNN value in milliseconds
  double calculateSdnn(List<double> rrIntervals);

  /// Calculate pNN50 (percentage of NN intervals differing by more than 50ms)
  ///
  /// [rrIntervals] RR intervals in milliseconds
  /// Returns pNN50 as percentage (0-100)
  double calculatePnn50(List<double> rrIntervals);

  /// Calculate additional HRV time-domain metrics
  ///
  /// [rrIntervals] RR intervals in milliseconds
  /// Returns map of additional metrics
  Future<Map<String, double>> calculateAdditionalMetrics(
    List<double> rrIntervals,
  );

  /// Validate RR intervals for quality and completeness
  ///
  /// [rrIntervals] RR intervals to validate
  /// Returns validation result with quality score
  ValidationResult validateRrIntervals(List<double> rrIntervals);
}

/// Abstract interface for heart rate analysis
///
/// Implements resting/maximum pulse analysis as specified in the development plan
abstract class HeartRateAnalyzer {
  /// Analyze heart rate data and determine zones
  ///
  /// [heartRateData] Heart rate measurements over time
  /// [rrIntervals] Corresponding RR intervals
  /// [userProfile] User profile for personalized analysis
  /// Returns comprehensive heart rate analysis
  Future<HeartRateAnalysis> analyzeHeartRate(
    List<HeartRateDataPoint> heartRateData,
    List<double> rrIntervals, {
    UserProfile? userProfile,
  });

  /// Estimate resting heart rate from data
  ///
  /// [heartRateData] Heart rate measurements
  /// Returns estimated resting heart rate in bpm
  Future<int> estimateRestingHeartRate(List<HeartRateDataPoint> heartRateData);

  /// Estimate maximum heart rate
  ///
  /// [heartRateData] Heart rate measurements
  /// [userAge] User age for age-based estimation
  /// Returns estimated maximum heart rate in bpm
  Future<int> estimateMaxHeartRate(
    List<HeartRateDataPoint> heartRateData, {
    int? userAge,
  });

  /// Determine current heart rate zone
  ///
  /// [currentHr] Current heart rate in bpm
  /// [restingHr] Resting heart rate in bpm
  /// [maxHr] Maximum heart rate in bpm
  /// Returns heart rate zone
  HeartRateZone determineHeartRateZone(int currentHr, int restingHr, int maxHr);
}

/// Abstract interface for stress indicator analysis
///
/// Implements sympathetic/parasympathetic analysis as specified in the development plan
abstract class StressAnalyzer {
  /// Analyze stress indicators from HRV and heart rate data
  ///
  /// [hrvMetrics] Calculated HRV metrics
  /// [heartRateAnalysis] Heart rate analysis results
  /// [timeOfDay] Time of measurement for context
  /// Returns stress indicator analysis
  Future<StressIndicator> analyzeStress(
    HrvMetrics hrvMetrics,
    HeartRateAnalysis heartRateAnalysis, {
    DateTime? timeOfDay,
  });

  /// Calculate sympathetic nervous system activity
  ///
  /// [hrvMetrics] HRV metrics for analysis
  /// [heartRateData] Heart rate variability data
  /// Returns sympathetic activity score (0.0-1.0)
  Future<double> calculateSympathetic(
    HrvMetrics hrvMetrics,
    List<double> heartRateData,
  );

  /// Calculate parasympathetic nervous system activity
  ///
  /// [hrvMetrics] HRV metrics for analysis
  /// Returns parasympathetic activity score (0.0-1.0)
  Future<double> calculateParasympathetic(HrvMetrics hrvMetrics);

  /// Calculate autonomic balance ratio
  ///
  /// [sympathetic] Sympathetic activity score
  /// [parasympathetic] Parasympathetic activity score
  /// Returns balance ratio (>1.0 = sympathetic dominance)
  double calculateBalanceRatio(double sympathetic, double parasympathetic);

  /// Assess overall stress level
  ///
  /// [sympathetic] Sympathetic activity
  /// [parasympathetic] Parasympathetic activity
  /// [context] Additional context factors
  /// Returns overall stress level (0.0-1.0)
  Future<double> assessStressLevel(
    double sympathetic,
    double parasympathetic, {
    StressContext? context,
  });
}

/// Heart rate data point with timestamp
class HeartRateDataPoint {
  const HeartRateDataPoint({
    required this.heartRate,
    required this.timestamp,
    this.quality,
  });

  /// Heart rate in beats per minute
  final int heartRate;

  /// Timestamp of measurement
  final DateTime timestamp;

  /// Signal quality indicator (0.0-1.0) - optional
  final double? quality;
}

/// User profile for personalized analysis
class UserProfile {
  const UserProfile({
    required this.age,
    this.gender,
    this.fitnessLevel,
    this.restingHeartRate,
    this.maxHeartRate,
  });

  /// User age in years
  final int age;

  /// User gender - optional
  final Gender? gender;

  /// Fitness level - optional
  final FitnessLevel? fitnessLevel;

  /// Known resting heart rate - optional
  final int? restingHeartRate;

  /// Known maximum heart rate - optional
  final int? maxHeartRate;
}

/// User gender
enum Gender { male, female, other }

/// User fitness level
enum FitnessLevel { sedentary, low, moderate, high, athlete }

/// Stress analysis context
class StressContext {
  const StressContext({
    this.timeOfDay,
    this.activity,
    this.environment,
    this.sleepQuality,
  });

  /// Time of day for circadian rhythm consideration
  final TimeOfDay? timeOfDay;

  /// Current activity type
  final ActivityType? activity;

  /// Environmental factors
  final Environment? environment;

  /// Recent sleep quality indicator
  final SleepQuality? sleepQuality;
}

/// Activity type for context
enum ActivityType { rest, lightActivity, moderateActivity, intenseActivity }

/// Environmental factors
enum Environment { indoor, outdoor, noisy, quiet, hot, cold }

/// Sleep quality indicator
enum SleepQuality { poor, fair, good, excellent }

/// Validation result for data quality
// ValidationResult is defined in 'validation_interfaces.dart' to avoid duplicate symbols

/// Time of day representation
enum TimeOfDay { morning, afternoon, evening, night }
