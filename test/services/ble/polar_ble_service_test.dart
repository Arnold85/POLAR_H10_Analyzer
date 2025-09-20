import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/services/ble/polar_ble_service.dart';
import 'package:polar_bridge/polar_bridge.dart' as bridge;

// We will simulate incoming events by directly invoking the PolarBridge event stream
// The PolarBleService listens on bridge.PolarBridge.instance.events. To avoid modifying the
// real singleton, we'll create a fake event controller and temporarily replace the instance
// used by the service. For simplicity in this test, we only test the parsing logic by
// invoking the handler indirectly through creating service and pushing events through
// bridge.PolarBridge.instance.events if available.

void main() {
  group('PolarBleService parsing', () {
    test('parses HR event with mixed rrs types', () async {
      // install test controller
      final ctl = StreamController<dynamic>.broadcast();
      bridge.PolarBridge.setTestController(ctl);
      final service = PolarBleService();

      final completer = Completer<void>();
      final sub = service.heartRateStream.listen(
        expectAsync1((sample) {
          expect(sample.heartRate, 64);
          expect(sample.rrIntervals, isNotEmpty);
          expect(sample.rrIntervals.first, 919);
          completer.complete();
        }),
      );

      // Emit a fake event via the test controller
      bridge.PolarBridge.emitTestEvent({
        'type': 'hr',
        'deviceId': 'X',
        'hr': 64,
        'rrs': [919, '898'],
        'ts': 1758382193892,
      });

      await completer.future;
      await sub.cancel();
      await ctl.close();
    });

    test(
      'parses ECG batch and reconstructs timestamps when missing samplingRate',
      () async {
        final ctl = StreamController<dynamic>.broadcast();
        bridge.PolarBridge.setTestController(ctl);
        final service = PolarBleService();

        final completer = Completer<void>();
        final sub = service.ecgStream.listen(
          expectAsync1((batch) {
            // samplingRate fallback expected
            expect(batch.samplingRate, equals(500.0));
            expect(batch.voltages, isNotEmpty);
            expect(batch.startTimestamp, isNotNull);
            expect(batch.endTimestamp, isNotNull);
            completer.complete();
          }),
        );

        final fakeSamples = List.generate(10, (i) => {'voltage': -300 + i});
        bridge.PolarBridge.emitTestEvent({
          'type': 'ecg',
          'deviceId': 'X',
          'samples': fakeSamples,
          'ts': 1758382200000,
        });

        await completer.future;
        await sub.cancel();
        await ctl.close();
      },
    );

    test('parses ECG batch with samplingRate provided', () async {
      final ctl = StreamController<dynamic>.broadcast();
      bridge.PolarBridge.setTestController(ctl);
      final service = PolarBleService();

      final completer = Completer<void>();
      final sub = service.ecgStream.listen(
        expectAsync1((batch) {
          expect(batch.samplingRate, equals(1000.0));
          expect(batch.voltages.length, equals(5));
          completer.complete();
        }),
      );

      final fakeSamples = [100, 200, 300, 400, 500];
      bridge.PolarBridge.emitTestEvent({
        'type': 'ecg',
        'deviceId': 'X',
        'samples': fakeSamples,
        'ts': 1758382201000,
        'samplingRate': 1000,
      });

      await completer.future;
      await sub.cancel();
      await ctl.close();
    });
  });
}
