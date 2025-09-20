import '../models/analysis_result.dart';
// imports removed; this interface references only AnalysisResult and related types

/// Abstract analysis engine interface
///
/// Provides the main abstraction layer for switching between local and cloud AI models
/// as specified in the development plan's KI-Strategie
abstract class AnalysisEngine {
  /// Initialize the analysis engine
  ///
  /// [config] Configuration for the engine
  /// Returns true if initialization was successful
  Future<bool> initialize(AnalysisEngineConfig config);

  /// Perform complete analysis on measurement data
  ///
  /// [sessionData] Raw measurement session data
  /// [options] Analysis options and preferences
  /// Returns comprehensive analysis result
  Future<AnalysisResult> performAnalysis(
    MeasurementSessionData sessionData, {
    AnalysisOptions? options,
  });

  /// Get AI-generated insights and interpretations
  ///
  /// [analysisResult] Base analysis results
  /// [context] Additional context for interpretation
  /// Returns AI insights with explanatory text
  Future<AiInsights> generateInsights(
    AnalysisResult analysisResult, {
    AnalysisContext? context,
  });

  /// Validate analysis results against known datasets
  ///
  /// [result] Analysis result to validate
  /// Returns validation metrics
  Future<ValidationMetrics> validateResults(AnalysisResult result);

  /// Check if the engine is currently available
  bool get isAvailable;

  /// Get the current engine type
  AnalysisEngineType get engineType;

  /// Clean up resources
  Future<void> dispose();
}

/// Abstract interface for local AI models using TensorFlow Lite
///
/// Implements local model strategy as specified in the development plan
abstract class LocalAnalysisModel {
  /// Load the TensorFlow Lite model
  ///
  /// [modelPath] Path to the .tflite model file
  /// Returns true if model loaded successfully
  Future<bool> loadModel(String modelPath);

  /// Predict HRV metrics from raw RR interval data
  ///
  /// [rrIntervals] RR intervals in milliseconds
  /// [features] Additional engineered features
  /// Returns predicted HRV metrics with confidence
  Future<ModelPrediction<HrvMetrics>> predictHrvMetrics(
    List<double> rrIntervals, {
    Map<String, double>? features,
  });

  /// Predict stress level from analysis data
  ///
  /// [inputData] Processed analysis input data
  /// Returns stress prediction with confidence
  Future<ModelPrediction<double>> predictStressLevel(
    Map<String, double> inputData,
  );

  /// Classify heart rate patterns
  ///
  /// [heartRateData] Time series heart rate data
  /// Returns pattern classification
  Future<ModelPrediction<HeartRatePattern>> classifyHeartRatePattern(
    List<double> heartRateData,
  );

  /// Get model information
  ModelInfo get modelInfo;

  /// Check if model is loaded and ready
  bool get isReady;

  /// Unload the model and free resources
  Future<void> unload();
}

/// Abstract interface for cloud-based LLM analysis
///
/// Implements optional cloud LLM strategy for explanatory text as specified in the development plan
abstract class CloudLlmAnalyzer {
  /// Initialize connection to cloud LLM service
  ///
  /// [config] Cloud service configuration
  /// Returns true if connection established
  Future<bool> initialize(CloudLlmConfig config);

  /// Generate explanatory text for analysis results
  ///
  /// [analysisResult] Complete analysis results
  /// [language] Language for explanations (default: German)
  /// Returns detailed explanatory text
  Future<String> generateExplanation(
    AnalysisResult analysisResult, {
    String language = 'de',
  });

  /// Get personalized recommendations
  ///
  /// [analysisResult] Analysis results
  /// [userProfile] User profile for personalization
  /// Returns list of recommendations
  Future<List<String>> generateRecommendations(
    AnalysisResult analysisResult, {
    Map<String, dynamic>? userProfile,
  });

  /// Interpret trends and patterns
  ///
  /// [historicalResults] List of previous analysis results
  /// [currentResult] Current analysis result
  /// Returns trend interpretation
  Future<String> interpretTrends(
    List<AnalysisResult> historicalResults,
    AnalysisResult currentResult,
  );

  /// Answer specific questions about analysis
  ///
  /// [question] User question about their analysis
  /// [context] Analysis context for answering
  /// Returns detailed answer
  Future<String> answerQuestion(String question, AnalysisResult context);

  /// Check if cloud service is available
  bool get isAvailable;

  /// Get current service status
  CloudServiceStatus get status;

  /// Disconnect from cloud service
  Future<void> disconnect();
}

/// Analysis engine configuration
class AnalysisEngineConfig {
  const AnalysisEngineConfig({
    required this.engineType,
    this.localModelPath,
    this.cloudConfig,
    this.enableValidation = true,
    this.qualityThreshold = 0.8,
  });

  /// Type of analysis engine to use
  final AnalysisEngineType engineType;

  /// Path to local TensorFlow Lite model - required for local engine
  final String? localModelPath;

  /// Cloud configuration - required for cloud engine
  final CloudLlmConfig? cloudConfig;

  /// Whether to enable validation against datasets
  final bool enableValidation;

  /// Minimum quality threshold for analysis (0.0-1.0)
  final double qualityThreshold;
}

/// Cloud LLM service configuration
class CloudLlmConfig {
  const CloudLlmConfig({
    required this.apiKey,
    required this.endpoint,
    this.model = 'gpt-4',
    this.maxTokens = 1000,
    this.temperature = 0.7,
  });

  /// API key for cloud service
  final String apiKey;

  /// Service endpoint URL
  final String endpoint;

  /// Model name to use
  final String model;

  /// Maximum tokens per request
  final int maxTokens;

  /// Temperature setting for text generation
  final double temperature;
}

/// Measurement session data for analysis
class MeasurementSessionData {
  const MeasurementSessionData({
    required this.sessionId,
    required this.startTime,
    required this.duration,
    required this.rrIntervals,
    required this.heartRateData,
    this.ecgSamples,
    this.metadata,
  });

  /// Unique session identifier
  final String sessionId;

  /// Session start timestamp
  final DateTime startTime;

  /// Session duration
  final Duration duration;

  /// RR intervals in milliseconds
  final List<double> rrIntervals;

  /// Heart rate measurements over time
  final List<double> heartRateData;

  /// Raw ECG samples - optional
  final List<double>? ecgSamples;

  /// Additional session metadata - optional
  final Map<String, dynamic>? metadata;
}

/// Analysis options and preferences
class AnalysisOptions {
  const AnalysisOptions({
    this.includeFrequencyDomain = true,
    this.includeTimeDomain = true,
    this.includeStressAnalysis = true,
    this.generateInsights = true,
    this.language = 'de',
    this.customParameters,
  });

  /// Whether to include frequency domain analysis
  final bool includeFrequencyDomain;

  /// Whether to include time domain analysis
  final bool includeTimeDomain;

  /// Whether to include stress analysis
  final bool includeStressAnalysis;

  /// Whether to generate AI insights
  final bool generateInsights;

  /// Language for insights and explanations
  final String language;

  /// Custom analysis parameters
  final Map<String, dynamic>? customParameters;
}

/// Analysis context for AI interpretation
class AnalysisContext {
  const AnalysisContext({
    this.timeOfDay,
    this.activityLevel,
    this.userAge,
    this.healthConditions,
    this.previousResults,
  });

  /// Time of day when measurement was taken
  final String? timeOfDay;

  /// Activity level during measurement
  final String? activityLevel;

  /// User age for context
  final int? userAge;

  /// Known health conditions
  final List<String>? healthConditions;

  /// Previous analysis results for comparison
  final List<AnalysisResult>? previousResults;
}

/// Model prediction result with confidence
class ModelPrediction<T> {
  const ModelPrediction({
    required this.prediction,
    required this.confidence,
    this.metadata,
  });

  /// The predicted value
  final T prediction;

  /// Confidence score (0.0-1.0)
  final double confidence;

  /// Additional prediction metadata
  final Map<String, dynamic>? metadata;
}

/// Model information
class ModelInfo {
  const ModelInfo({
    required this.name,
    required this.version,
    required this.accuracy,
    this.description,
    this.trainingDataset,
  });

  /// Model name
  final String name;

  /// Model version
  final String version;

  /// Model accuracy on validation set
  final double accuracy;

  /// Model description
  final String? description;

  /// Training dataset information
  final String? trainingDataset;
}

/// Heart rate pattern classifications
enum HeartRatePattern {
  normal,
  irregular,
  tachycardia,
  bradycardia,
  fibrillation,
}

/// Analysis engine types
enum AnalysisEngineType { local, cloud, hybrid }

/// Cloud service status
enum CloudServiceStatus { connected, disconnected, error, rateLimited }
