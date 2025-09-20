import 'dart:async';

import '../../domain/models/heart_rate_sample.dart';
import '../../domain/models/ecg_sample.dart';
import '../../domain/models/polar_device.dart';
import '../../domain/models/connection_event.dart'; // Added import for ConnectionEvent

abstract class BleService {
  Stream<ConnectionEvent> get connectionEvents;
  Stream<HeartRateSample> get heartRateStream;
  Stream<EcgSampleBatch> get ecgStream;
  Stream<PolarDevice> get scanResults;

  Future<void> initialize({bool enableEcg = true, bool enableHr = true});
  Future<void> startScan();
  Future<void> stopScan();
  Future<void> connect(String deviceId);
  Future<void> disconnect(String deviceId);
}
