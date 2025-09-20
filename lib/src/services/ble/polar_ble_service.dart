import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:polar_bridge/polar_bridge.dart' as bridge;

// Domain models
import '../../domain/models/connection_event.dart' as domain;
import '../../domain/models/heart_rate_sample.dart' as domain;
import '../../domain/models/ecg_sample.dart' as domain;
import '../../domain/models/polar_device.dart' as domain;
import 'ble_service.dart';

class PolarBleService implements BleService {
  final _connectionController =
      StreamController<domain.ConnectionEvent>.broadcast();
  final _hrController = StreamController<domain.HeartRateSample>.broadcast();
  final _ecgController = StreamController<domain.EcgSampleBatch>.broadcast();
  final _scanController = StreamController<domain.PolarDevice>.broadcast();

  PolarBleService() {
    // wire plugin events
    bridge.PolarBridge.instance.events.listen((e) {
      // Print raw plugin events to the terminal for debugging as JSON-friendly single-line
      try {
        // Using describeEnum/jsonEncode would be heavier; to keep logs readable convert to string safely
        debugPrint('PolarBridge event: ${e.toString()}');
      } catch (_) {}
      final type = (e is Map) ? e['type'] : null;
      switch (type) {
        case 'connection':
          final state = (domain.DeviceConnectionStatus.values.firstWhere(
            (s) => s.name == (e['state'] as String? ?? ''),
            orElse: () => domain.DeviceConnectionStatus.disconnected,
          ));
          _connectionController.add(
            domain.ConnectionEvent(e['deviceId'] as String, state),
          );
          break;
        case 'hr':
          try {
            final tsVal = (e['ts'] is int)
                ? e['ts'] as int
                : (e['ts'] is double ? (e['ts'] as double).toInt() : null);
            final rrs = <int>[];
            if (e['rrs'] is List) {
              for (final v in (e['rrs'] as List)) {
                if (v is int)
                  rrs.add(v);
                else if (v is double)
                  rrs.add(v.toInt());
                else if (v is String)
                  rrs.add(int.tryParse(v) ?? 0);
              }
            }
            _hrController.add(
              domain.HeartRateSample(
                sessionId: '',
                timestamp: DateTime.fromMillisecondsSinceEpoch(
                  tsVal ?? DateTime.now().millisecondsSinceEpoch,
                ),
                heartRate: (e['hr'] is int)
                    ? e['hr'] as int
                    : (e['hr'] is double ? (e['hr'] as double).toInt() : 0),
                rrIntervals: rrs,
                contactDetected: true,
                source: domain.HeartRateSource.chestStrap,
                quality: 0,
              ),
            );
          } catch (_) {}
          break;
        case 'ecg':
          try {
            // Prefer explicit startTimeStamp from native plugin when available; fall back to the batch 'ts' field.
            final maybeStart =
                e['startTimeStamp'] ?? e['startTimestamp'] ?? e['start_ts'];
            final maybeTs = e['ts'] ?? e['timestamp'];
            // Normalize start timestamp to integer milliseconds
            final int startTs;
            if (maybeStart is int) {
              startTs = maybeStart;
            } else if (maybeStart is double) {
              startTs = maybeStart.toInt();
            } else if (maybeTs is int) {
              startTs = maybeTs;
            } else if (maybeTs is double) {
              startTs = maybeTs.toInt();
            } else {
              startTs = DateTime.now().millisecondsSinceEpoch;
            }

            // Prefer samplingRate supplied by native plugin; accept int or double. Fallback to 500 Hz if missing.
            final samplingRateNum = e['samplingRate'];
            final double sr = (samplingRateNum is int)
                ? samplingRateNum.toDouble()
                : (samplingRateNum is double)
                ? samplingRateNum
                : 500.0;

            final rawSamples = e['samples'];
            final List<double> voltages = [];
            final List<int> rPeaks = [];
            bool anySampleHasTs = false;
            final List<int?> perSampleTs = [];

            if (rawSamples is List) {
              // Samples may be primitives (numbers) or maps with 'voltage'/'timeStamp'
              for (final s in rawSamples) {
                if (s is num) {
                  voltages.add(s.toDouble());
                  perSampleTs.add(null);
                } else if (s is Map) {
                  final v =
                      s['voltage'] ??
                      s['value'] ??
                      s['volt'] ??
                      s['microvolts'];
                  if (v is num) {
                    voltages.add(v.toDouble());
                  } else if (v is String) {
                    voltages.add(double.tryParse(v) ?? 0.0);
                  } else {
                    voltages.add(0.0);
                  }

                  // attempt to read per-sample timestamp
                  final tsS = s['timeStamp'] ?? s['timestamp'] ?? s['ts'];
                  if (tsS is int) {
                    perSampleTs.add(tsS);
                    anySampleHasTs = true;
                  } else if (tsS is double) {
                    perSampleTs.add(tsS.toInt());
                    anySampleHasTs = true;
                  } else {
                    perSampleTs.add(null);
                  }

                  // optional r-peak marker
                  final isR = s['rPeak'] ?? s['isR'] ?? s['is_r'] ?? false;
                  if (isR == true) rPeaks.add(voltages.length - 1);
                } else if (s is String) {
                  voltages.add(double.tryParse(s) ?? 0.0);
                  perSampleTs.add(null);
                }
              }
            }

            final int sampleCount = voltages.length;

            // Determine per-sample timestamps. If native provided per-sample timestamps, use them.
            // Otherwise, reconstruct timestamps using an explicit start timestamp when available (preferred).
            final double dtMs = 1000.0 / sr;
            final List<DateTime> sampleTimestamps = List<DateTime>.filled(
              sampleCount,
              DateTime.fromMillisecondsSinceEpoch(startTs),
            );

            if (anySampleHasTs) {
              for (var i = 0; i < sampleCount; i++) {
                final v = perSampleTs[i];
                if (v != null) {
                  sampleTimestamps[i] = DateTime.fromMillisecondsSinceEpoch(v);
                } else {
                  sampleTimestamps[i] = DateTime.fromMillisecondsSinceEpoch(
                    (startTs + (i * dtMs)).round(),
                  );
                }
              }
            } else {
              // No per-sample timestamps provided — reconstruct from startTs forward
              for (var i = 0; i < sampleCount; i++) {
                sampleTimestamps[i] = DateTime.fromMillisecondsSinceEpoch(
                  (startTs + (i * dtMs)).round(),
                );
              }
            }

            // Determine batch start/end from computed sample timestamps
            final DateTime batchStart = sampleTimestamps.isNotEmpty
                ? sampleTimestamps.first
                : DateTime.fromMillisecondsSinceEpoch(startTs);
            final DateTime batchEnd = sampleTimestamps.isNotEmpty
                ? sampleTimestamps.last
                : DateTime.fromMillisecondsSinceEpoch(
                    (startTs + ((sampleCount - 1) * dtMs).round()),
                  );

            if (samplingRateNum == null) {
              debugPrint(
                'PolarBleService: ecg event missing samplingRate; using fallback $sr Hz. Native plugin now emits samplingRate where possible.',
              );
            }

            // Basic sanity checks: clamp extreme values and trim empty batches
            final List<double> cleanedVoltages = voltages.map((v) {
              if (v.isInfinite || v.isNaN) return 0.0;
              // clamp to plausible range for raw device counts
              if (v > 10000) return 10000.0;
              if (v < -10000) return -10000.0;
              return v;
            }).toList();

            if (cleanedVoltages.isNotEmpty) {
              _ecgController.add(
                domain.EcgSampleBatch(
                  sessionId: '',
                  startTimestamp: batchStart,
                  endTimestamp: batchEnd,
                  samplingRate: sr,
                  voltages: cleanedVoltages,
                  rPeakIndices: rPeaks,
                  batchNumber: 0,
                ),
              );
            }
          } catch (err, st) {
            debugPrint('PolarBleService ecg parse error: $err\n$st');
          }
          break;
        case 'scanResult':
          _scanController.add(
            domain.PolarDevice(
              deviceId: e['deviceId'] as String,
              name: (e['name'] as String?) ?? '',
              firmwareVersion: null,
              batteryLevel: null,
              connectionStatus: domain.DeviceConnectionStatus.disconnected,
              signalQuality: (e['rssi'] as int?) ?? 0,
              electrodeStatus: domain.ElectrodeStatus.unknown,
              lastSeen: DateTime.now(),
            ),
          );
          break;
        default:
          break;
      }
    });
  }

  @override
  Stream<domain.ConnectionEvent> get connectionEvents =>
      _connectionController.stream;

  @override
  Stream<domain.HeartRateSample> get heartRateStream => _hrController.stream;

  @override
  Stream<domain.EcgSampleBatch> get ecgStream => _ecgController.stream;

  @override
  Stream<domain.PolarDevice> get scanResults => _scanController.stream;

  @override
  Future<void> connect(String deviceId) =>
      bridge.PolarBridge.instance.connect(deviceId);

  @override
  Future<void> disconnect(String deviceId) =>
      bridge.PolarBridge.instance.disconnect(deviceId);

  @override
  Future<void> initialize({bool enableEcg = true, bool enableHr = true}) =>
      bridge.PolarBridge.instance.initialize(
        enableEcg: enableEcg,
        enableHr: enableHr,
      );

  @override
  Future<void> startScan() => bridge.PolarBridge.instance.startScan();

  @override
  Future<void> stopScan() => bridge.PolarBridge.instance.stopScan();
}
