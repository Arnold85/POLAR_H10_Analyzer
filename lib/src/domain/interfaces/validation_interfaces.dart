import '../models/analysis_result.dart';

/// Abstract interface for metrics validation
/// 
/// Implements validation against public datasets and QA process
/// as specified in the development plan
abstract class MetricsValidator {
  /// Validate analysis results against reference datasets
  /// 
  /// [result] Analysis result to validate
  /// [referenceDataset] Name of reference dataset to compare against
  /// Returns validation metrics including accuracy and sensitivity
  Future<ValidationResult> validateAgainstDataset(
    AnalysisResult result,
    String referenceDataset,
  );

  /// Calculate accuracy metrics for HRV analysis
  /// 
  /// [predictedMetrics] Predicted HRV values
  /// [groundTruthMetrics] Ground truth values from reference
  /// Returns accuracy assessment
  Future<AccuracyMetrics> calculateAccuracy(
    Map<String, double> predictedMetrics,
    Map<String, double> groundTruthMetrics,
  );

  /// Calculate sensitivity and specificity for classification tasks
  /// 
  /// [predictions] Model predictions
  /// [groundTruth] True classifications
  /// Returns sensitivity and specificity metrics
  Future<ClassificationMetrics> calculateClassificationMetrics(
    List<bool> predictions,
    List<bool> groundTruth,
  );

  /// Validate signal quality and completeness
  /// 
  /// [signalData] Raw signal data to validate
  /// [expectedDuration] Expected duration of signal
  /// Returns signal quality assessment
  Future<SignalQualityMetrics> validateSignalQuality(
    List<double> signalData,
    Duration expectedDuration,
  );

  /// Get available reference datasets
  List<String> get availableDatasets;

  /// Load reference dataset for validation
  /// 
  /// [datasetName] Name of the dataset to load
  /// Returns reference data or null if not available
  Future<ReferenceDataset?> loadReferenceDataset(String datasetName);
}

/// Abstract interface for quality assurance process
/// 
/// Implements QA process as specified in the development plan
abstract class QualityAssurance {
  /// Perform comprehensive quality check on analysis pipeline
  /// 
  /// [sessionData] Input session data
  /// [analysisResult] Generated analysis result
  /// Returns QA assessment with recommendations
  Future<QaAssessment> performQualityCheck(
    MeasurementSessionData sessionData,
    AnalysisResult analysisResult,
  );

  /// Validate data preprocessing steps
  /// 
  /// [rawData] Original raw data
  /// [processedData] Data after preprocessing
  /// Returns preprocessing validation result
  Future<PreprocessingValidation> validatePreprocessing(
    List<double> rawData,
    List<double> processedData,
  );

  /// Check for potential analysis errors or anomalies
  /// 
  /// [result] Analysis result to check
  /// Returns list of potential issues found
  Future<List<QualityIssue>> detectPotentialIssues(AnalysisResult result);

  /// Validate analysis consistency across multiple runs
  /// 
  /// [results] Multiple analysis results from same data
  /// Returns consistency assessment
  Future<ConsistencyAssessment> validateConsistency(
    List<AnalysisResult> results,
  );

  /// Generate quality report for analysis session
  /// 
  /// [sessionData] Session data
  /// [analysisResult] Analysis results
  /// [qaAssessment] QA assessment results
  /// Returns formatted quality report
  Future<QualityReport> generateQualityReport(
    MeasurementSessionData sessionData,
    AnalysisResult analysisResult,
    QaAssessment qaAssessment,
  );
}

/// Validation result with detailed metrics
class ValidationResult {
  const ValidationResult({
    required this.isValid,
    required this.accuracy,
    required this.sensitivity,
    required this.specificity,
    required this.validatedAt,
    this.precision,
    this.recall,
    this.f1Score,
    this.issues,
    this.recommendations,
  });

  /// Whether validation passed
  final bool isValid;

  /// Overall accuracy (0.0-1.0)
  final double accuracy;

  /// Sensitivity (true positive rate) (0.0-1.0)
  final double sensitivity;

  /// Specificity (true negative rate) (0.0-1.0)
  final double specificity;

  /// When validation was performed
  final DateTime validatedAt;

  /// Precision (positive predictive value) (0.0-1.0) - optional
  final double? precision;

  /// Recall (same as sensitivity) (0.0-1.0) - optional
  final double? recall;

  /// F1 score (harmonic mean of precision and recall) (0.0-1.0) - optional
  final double? f1Score;

  /// List of identified issues - optional
  final List<String>? issues;

  /// Recommendations for improvement - optional
  final List<String>? recommendations;
}

/// Accuracy metrics for numerical predictions
class AccuracyMetrics {
  const AccuracyMetrics({
    required this.meanAbsoluteError,
    required this.meanSquaredError,
    required this.rootMeanSquaredError,
    required this.meanAbsolutePercentageError,
    this.r2Score,
    this.correlationCoefficient,
  });

  /// Mean Absolute Error
  final double meanAbsoluteError;

  /// Mean Squared Error
  final double meanSquaredError;

  /// Root Mean Squared Error
  final double rootMeanSquaredError;

  /// Mean Absolute Percentage Error (%)
  final double meanAbsolutePercentageError;

  /// R-squared score - optional
  final double? r2Score;

  /// Correlation coefficient - optional
  final double? correlationCoefficient;
}

/// Classification metrics for binary classification
class ClassificationMetrics {
  const ClassificationMetrics({
    required this.accuracy,
    required this.sensitivity,
    required this.specificity,
    required this.precision,
    required this.recall,
    required this.f1Score,
    required this.confusionMatrix,
  });

  /// Overall accuracy (0.0-1.0)
  final double accuracy;

  /// Sensitivity/True Positive Rate (0.0-1.0)
  final double sensitivity;

  /// Specificity/True Negative Rate (0.0-1.0)
  final double specificity;

  /// Precision/Positive Predictive Value (0.0-1.0)
  final double precision;

  /// Recall (same as sensitivity) (0.0-1.0)
  final double recall;

  /// F1 Score (0.0-1.0)
  final double f1Score;

  /// Confusion matrix [TP, FP, TN, FN]
  final List<int> confusionMatrix;
}

/// Signal quality metrics
class SignalQualityMetrics {
  const SignalQualityMetrics({
    required this.overallQuality,
    required this.completeness,
    required this.signalToNoiseRatio,
    required this.artifactPercentage,
    this.samplingRateConsistency,
    this.dynamicRange,
  });

  /// Overall signal quality score (0.0-1.0)
  final double overallQuality;

  /// Data completeness percentage (0.0-1.0)
  final double completeness;

  /// Signal-to-noise ratio (dB)
  final double signalToNoiseRatio;

  /// Percentage of signal identified as artifacts (0.0-1.0)
  final double artifactPercentage;

  /// Consistency of sampling rate - optional
  final double? samplingRateConsistency;

  /// Dynamic range of the signal - optional
  final double? dynamicRange;
}

/// Reference dataset for validation
class ReferenceDataset {
  const ReferenceDataset({
    required this.name,
    required this.description,
    required this.sampleCount,
    required this.groundTruthData,
    this.metadata,
    this.citationInfo,
  });

  /// Dataset name
  final String name;

  /// Dataset description
  final String description;

  /// Number of samples in dataset
  final int sampleCount;

  /// Ground truth data for comparison
  final Map<String, dynamic> groundTruthData;

  /// Additional dataset metadata - optional
  final Map<String, dynamic>? metadata;

  /// Citation information - optional
  final String? citationInfo;
}

/// Quality assurance assessment
class QaAssessment {
  const QaAssessment({
    required this.overallScore,
    required this.passedChecks,
    required this.totalChecks,
    required this.assessedAt,
    this.criticalIssues,
    this.warnings,
    this.recommendations,
  });

  /// Overall QA score (0.0-1.0)
  final double overallScore;

  /// Number of checks that passed
  final int passedChecks;

  /// Total number of checks performed
  final int totalChecks;

  /// When assessment was performed
  final DateTime assessedAt;

  /// Critical issues found - optional
  final List<QualityIssue>? criticalIssues;

  /// Warnings identified - optional
  final List<QualityIssue>? warnings;

  /// Recommendations for improvement - optional
  final List<String>? recommendations;
}

/// Preprocessing validation result
class PreprocessingValidation {
  const PreprocessingValidation({
    required this.isValid,
    required this.dataIntegrity,
    required this.filteringQuality,
    this.artifactRemovalEffectiveness,
    this.issues,
  });

  /// Whether preprocessing is valid
  final bool isValid;

  /// Data integrity score (0.0-1.0)
  final double dataIntegrity;

  /// Quality of filtering applied (0.0-1.0)
  final double filteringQuality;

  /// Effectiveness of artifact removal (0.0-1.0) - optional
  final double? artifactRemovalEffectiveness;

  /// Issues identified during preprocessing - optional
  final List<String>? issues;
}

/// Quality issue identified during QA
class QualityIssue {
  const QualityIssue({
    required this.severity,
    required this.category,
    required this.description,
    this.suggestedAction,
    this.affectedMetrics,
  });

  /// Severity level of the issue
  final IssueSeverity severity;

  /// Category of the issue
  final IssueCategory category;

  /// Detailed description of the issue
  final String description;

  /// Suggested action to resolve - optional
  final String? suggestedAction;

  /// Metrics affected by this issue - optional
  final List<String>? affectedMetrics;
}

/// Consistency assessment across multiple runs
class ConsistencyAssessment {
  const ConsistencyAssessment({
    required this.consistencyScore,
    required this.variationCoefficient,
    required this.outlierCount,
    this.maxDeviation,
    this.inconsistentMetrics,
  });

  /// Overall consistency score (0.0-1.0)
  final double consistencyScore;

  /// Coefficient of variation across runs
  final double variationCoefficient;

  /// Number of outlier results
  final int outlierCount;

  /// Maximum deviation from mean - optional
  final double? maxDeviation;

  /// Metrics showing inconsistency - optional
  final List<String>? inconsistentMetrics;
}

/// Quality report for analysis session
class QualityReport {
  const QualityReport({
    required this.sessionId,
    required this.generatedAt,
    required this.overallGrade,
    required this.summary,
    required this.detailedFindings,
    this.recommendations,
    this.validationResults,
  });

  /// Session ID this report covers
  final String sessionId;

  /// When report was generated
  final DateTime generatedAt;

  /// Overall quality grade (A, B, C, D, F)
  final String overallGrade;

  /// Executive summary of quality assessment
  final String summary;

  /// Detailed findings and metrics
  final Map<String, dynamic> detailedFindings;

  /// Recommendations for improvement - optional
  final List<String>? recommendations;

  /// Validation results against datasets - optional
  final List<ValidationResult>? validationResults;
}

/// Session data placeholder (to be defined in data layer)
class MeasurementSessionData {
  const MeasurementSessionData({
    required this.sessionId,
    required this.data,
  });

  final String sessionId;
  final Map<String, dynamic> data;
}

/// Issue severity levels
enum IssueSeverity {
  critical,
  high,
  medium,
  low,
  info,
}

/// Issue categories
enum IssueCategory {
  dataQuality,
  signalProcessing,
  analysis,
  validation,
  performance,
}