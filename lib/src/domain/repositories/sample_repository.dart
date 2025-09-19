import '../models/ecg_sample.dart';
import '../models/heart_rate_sample.dart';

/// Repository interface for sample data management (ECG and HR)
abstract class SampleRepository {
  // ECG Sample operations
  
  /// Save ECG samples in batch
  Future<void> saveEcgSamples(List<EcgSample> samples);
  
  /// Save ECG sample batch (more efficient for bulk operations)
  Future<void> saveEcgBatch(EcgSampleBatch batch);
  
  /// Get ECG samples for a session
  Future<List<EcgSample>> getEcgSamples(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
    int? offset,
  });
  
  /// Get ECG samples in batches for efficient processing
  Future<List<EcgSampleBatch>> getEcgBatches(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });
  
  /// Get ECG sample count for a session
  Future<int> getEcgSampleCount(String sessionId);
  
  /// Delete ECG samples for a session
  Future<void> deleteEcgSamples(String sessionId);
  
  // Heart Rate Sample operations
  
  /// Save heart rate samples
  Future<void> saveHeartRateSamples(List<HeartRateSample> samples);
  
  /// Get heart rate samples for a session
  Future<List<HeartRateSample>> getHeartRateSamples(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
    int? offset,
  });
  
  /// Save HRV samples
  Future<void> saveHrvSamples(List<HrvSample> samples);
  
  /// Get HRV samples for a session
  Future<List<HrvSample>> getHrvSamples(
    String sessionId, {
    DateTime? startTime,
    DateTime? endTime,
    int? limit,
  });
  
  /// Get heart rate sample count for a session
  Future<int> getHeartRateSampleCount(String sessionId);
  
  /// Delete heart rate samples for a session
  Future<void> deleteHeartRateSamples(String sessionId);
  
  // Data chunking and optimization operations
  
  /// Optimize storage by chunking old data
  Future<void> optimizeSessionData(String sessionId);
  
  /// Get storage statistics
  Future<StorageStatistics> getStorageStatistics();
}

/// Storage statistics for monitoring database size and performance
class StorageStatistics {
  final int totalSessions;
  final int totalEcgSamples;
  final int totalHeartRateSamples;
  final int totalHrvSamples;
  final double databaseSizeMB;
  final DateTime lastOptimized;

  const StorageStatistics({
    required this.totalSessions,
    required this.totalEcgSamples,
    required this.totalHeartRateSamples,
    required this.totalHrvSamples,
    required this.databaseSizeMB,
    required this.lastOptimized,
  });
}