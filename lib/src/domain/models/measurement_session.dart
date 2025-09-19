import 'package:json_annotation/json_annotation.dart';

part 'measurement_session.g.dart';

/// Domain model representing a measurement session
@JsonSerializable()
class MeasurementSession {
  /// Unique session identifier
  final String sessionId;
  
  /// Associated device ID
  final String deviceId;
  
  /// Session start timestamp
  final DateTime startTime;
  
  /// Session end timestamp (null for ongoing sessions)
  final DateTime? endTime;
  
  /// Session status
  final SessionStatus status;
  
  /// Session type/category
  final SessionType type;
  
  /// User-defined tags for categorization
  final List<String> tags;
  
  /// Session notes/description
  final String? notes;
  
  /// Total duration in seconds (calculated)
  int get durationSeconds => endTime != null 
      ? endTime!.difference(startTime).inSeconds 
      : DateTime.now().difference(startTime).inSeconds;
  
  /// Whether session is currently recording
  bool get isRecording => status == SessionStatus.recording;
  
  /// Whether session is completed
  bool get isCompleted => status == SessionStatus.completed;

  const MeasurementSession({
    required this.sessionId,
    required this.deviceId,
    required this.startTime,
    this.endTime,
    required this.status,
    required this.type,
    this.tags = const [],
    this.notes,
  });

  factory MeasurementSession.fromJson(Map<String, dynamic> json) =>
      _$MeasurementSessionFromJson(json);

  Map<String, dynamic> toJson() => _$MeasurementSessionToJson(this);

  MeasurementSession copyWith({
    String? sessionId,
    String? deviceId,
    DateTime? startTime,
    DateTime? endTime,
    SessionStatus? status,
    SessionType? type,
    List<String>? tags,
    String? notes,
  }) {
    return MeasurementSession(
      sessionId: sessionId ?? this.sessionId,
      deviceId: deviceId ?? this.deviceId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasurementSession &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId;

  @override
  int get hashCode => sessionId.hashCode;

  @override
  String toString() {
    return 'MeasurementSession{sessionId: $sessionId, deviceId: $deviceId, status: $status, duration: ${durationSeconds}s}';
  }
}

/// Session recording status
enum SessionStatus {
  @JsonValue('preparing')
  preparing,
  @JsonValue('recording')
  recording,
  @JsonValue('paused')
  paused,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('error')
  error,
}

/// Session type/category
enum SessionType {
  @JsonValue('resting')
  resting,
  @JsonValue('exercise')
  exercise,
  @JsonValue('stress_test')
  stressTest,
  @JsonValue('recovery')
  recovery,
  @JsonValue('sleep')
  sleep,
  @JsonValue('general')
  general,
}