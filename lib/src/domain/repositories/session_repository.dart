import '../models/measurement_session.dart';

/// Repository interface for measurement session management
abstract class SessionRepository {
  /// Get all sessions
  Future<List<MeasurementSession>> getSessions();
  
  /// Get sessions filtered by criteria
  Future<List<MeasurementSession>> getSessionsFiltered({
    String? deviceId,
    SessionStatus? status,
    SessionType? type,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
  });
  
  /// Get session by ID
  Future<MeasurementSession?> getSession(String sessionId);
  
  /// Create new session
  Future<String> createSession(MeasurementSession session);
  
  /// Update existing session
  Future<void> updateSession(MeasurementSession session);
  
  /// Delete session and all associated data
  Future<void> deleteSession(String sessionId);
  
  /// Get session statistics
  Future<SessionStatistics> getSessionStatistics(String sessionId);
  
  /// Get recent sessions (last N sessions)
  Future<List<MeasurementSession>> getRecentSessions(int limit);
}

/// Statistics for a measurement session
class SessionStatistics {
  final String sessionId;
  final int totalEcgSamples;
  final int totalHeartRateSamples;
  final int analysisCount;
  final DateTime? firstSampleTime;
  final DateTime? lastSampleTime;

  const SessionStatistics({
    required this.sessionId,
    required this.totalEcgSamples,
    required this.totalHeartRateSamples,
    required this.analysisCount,
    this.firstSampleTime,
    this.lastSampleTime,
  });
}