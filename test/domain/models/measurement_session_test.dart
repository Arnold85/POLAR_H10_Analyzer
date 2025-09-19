import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/domain/models/measurement_session.dart';

void main() {
  group('MeasurementSession', () {
    test('should create a valid MeasurementSession instance', () {
      final startTime = DateTime.now();
      final session = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: startTime,
        status: SessionStatus.recording,
        type: SessionType.exercise,
        tags: ['workout', 'morning'],
        notes: 'Morning run session',
      );

      expect(session.sessionId, 'SESSION123');
      expect(session.deviceId, 'DEVICE123');
      expect(session.startTime, startTime);
      expect(session.status, SessionStatus.recording);
      expect(session.type, SessionType.exercise);
      expect(session.tags, ['workout', 'morning']);
      expect(session.notes, 'Morning run session');
    });

    test('should calculate duration correctly for ongoing session', () {
      final startTime = DateTime.now().subtract(const Duration(minutes: 30));
      final session = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: startTime,
        status: SessionStatus.recording,
        type: SessionType.exercise,
      );

      expect(session.durationSeconds, greaterThan(1790)); // ~30 minutes
      expect(session.durationSeconds, lessThan(1810)); // Allow some tolerance
    });

    test('should calculate duration correctly for completed session', () {
      final startTime = DateTime.parse('2023-01-01T10:00:00Z');
      final endTime = DateTime.parse('2023-01-01T10:45:00Z');
      
      final session = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: startTime,
        endTime: endTime,
        status: SessionStatus.completed,
        type: SessionType.exercise,
      );

      expect(session.durationSeconds, 2700); // 45 minutes
    });

    test('should check recording status correctly', () {
      final session1 = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: DateTime.now(),
        status: SessionStatus.recording,
        type: SessionType.exercise,
      );

      final session2 = MeasurementSession(
        sessionId: 'SESSION456',
        deviceId: 'DEVICE123',
        startTime: DateTime.now(),
        status: SessionStatus.completed,
        type: SessionType.exercise,
      );

      expect(session1.isRecording, true);
      expect(session1.isCompleted, false);
      expect(session2.isRecording, false);
      expect(session2.isCompleted, true);
    });

    test('should support copyWith functionality', () {
      final originalSession = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: DateTime.now(),
        status: SessionStatus.recording,
        type: SessionType.exercise,
        tags: ['original'],
      );

      final updatedSession = originalSession.copyWith(
        status: SessionStatus.completed,
        endTime: DateTime.now(),
        tags: ['updated', 'completed'],
        notes: 'Session completed successfully',
      );

      expect(updatedSession.sessionId, originalSession.sessionId);
      expect(updatedSession.status, SessionStatus.completed);
      expect(updatedSession.endTime, isNotNull);
      expect(updatedSession.tags, ['updated', 'completed']);
      expect(updatedSession.notes, 'Session completed successfully');
    });

    test('should implement equality correctly', () {
      final session1 = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: DateTime.now(),
        status: SessionStatus.recording,
        type: SessionType.exercise,
      );

      final session2 = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DIFFERENT456',
        startTime: DateTime.now(),
        status: SessionStatus.completed,
        type: SessionType.resting,
      );

      final session3 = MeasurementSession(
        sessionId: 'DIFFERENT456',
        deviceId: 'DEVICE123',
        startTime: DateTime.now(),
        status: SessionStatus.recording,
        type: SessionType.exercise,
      );

      expect(session1, equals(session2)); // Same sessionId
      expect(session1, isNot(equals(session3))); // Different sessionId
    });

    test('should handle JSON serialization', () {
      final startTime = DateTime.parse('2023-01-01T10:00:00Z');
      final endTime = DateTime.parse('2023-01-01T10:45:00Z');
      
      final session = MeasurementSession(
        sessionId: 'SESSION123',
        deviceId: 'DEVICE123',
        startTime: startTime,
        endTime: endTime,
        status: SessionStatus.completed,
        type: SessionType.exercise,
        tags: ['workout', 'test'],
        notes: 'Test session',
      );

      final json = session.toJson();
      expect(json['sessionId'], 'SESSION123');
      expect(json['status'], 'completed');
      expect(json['type'], 'exercise');
      expect(json['tags'], ['workout', 'test']);

      final sessionFromJson = MeasurementSession.fromJson(json);
      expect(sessionFromJson.sessionId, session.sessionId);
      expect(sessionFromJson.status, session.status);
      expect(sessionFromJson.type, session.type);
      expect(sessionFromJson.tags, session.tags);
    });
  });

  group('SessionStatus', () {
    test('should have correct string values', () {
      expect(SessionStatus.preparing.name, 'preparing');
      expect(SessionStatus.recording.name, 'recording');
      expect(SessionStatus.paused.name, 'paused');
      expect(SessionStatus.completed.name, 'completed');
      expect(SessionStatus.cancelled.name, 'cancelled');
      expect(SessionStatus.error.name, 'error');
    });
  });

  group('SessionType', () {
    test('should have correct string values', () {
      expect(SessionType.resting.name, 'resting');
      expect(SessionType.exercise.name, 'exercise');
      expect(SessionType.stressTest.name, 'stressTest');
      expect(SessionType.recovery.name, 'recovery');
      expect(SessionType.sleep.name, 'sleep');
      expect(SessionType.general.name, 'general');
    });
  });
}