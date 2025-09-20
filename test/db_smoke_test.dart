import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/data/datasources/local/app_database.dart';
import 'package:drift/native.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AppDatabase can insert and query a measurement session', () async {
    // Use an in-memory NativeDatabase to avoid platform channels (path_provider)
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    // Ensure DB opens and migrations run
    final now = DateTime.now();

    // Insert a session
    await db
        .into(db.measurementSessions)
        .insert(
          MeasurementSessionsCompanion.insert(
            sessionId: 'smoke-session-1',
            deviceId: 'device-1',
            startTime: now,
            status: 'recording',
            type: 'exercise',
          ),
        );

    // Query sessions
    final sessions = await db.select(db.measurementSessions).get();
    expect(sessions, isNotEmpty);
    expect(sessions.first.sessionId, equals('smoke-session-1'));

    await db.close();
  });
}

// No test subclass required: use `AppDatabase.forTesting` constructor instead.
