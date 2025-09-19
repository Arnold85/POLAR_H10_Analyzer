import 'dart:convert';
import '../../domain/models/models.dart';
import 'package:drift/drift.dart' show Value;
import '../datasources/local/app_database.dart' as db;

/// Extension to convert database entities to domain models
extension PolarDeviceMapper on PolarDevice {
  /// Convert domain model to database companion
  db.PolarDevicesCompanion toCompanion() {
    return db.PolarDevicesCompanion.insert(
  deviceId: deviceId,
  name: name,
      firmwareVersion: Value(firmwareVersion),
      batteryLevel: Value(batteryLevel),
      connectionStatus: connectionStatus.name,
      signalQuality: Value(signalQuality),
      electrodeStatus: electrodeStatus.name,
      lastSeen: lastSeen,
    );
  }

  /// Update database companion with domain model
  db.PolarDevicesCompanion toUpdateCompanion() {
    return db.PolarDevicesCompanion(
      deviceId: Value(deviceId),
      name: Value(name),
      firmwareVersion: Value(firmwareVersion),
      batteryLevel: Value(batteryLevel),
      connectionStatus: Value(connectionStatus.name),
      signalQuality: Value(signalQuality),
      electrodeStatus: Value(electrodeStatus.name),
      lastSeen: Value(lastSeen),
      updatedAt: Value(DateTime.now()),
    );
  }
}

extension PolarDeviceEntityMapper on db.PolarDevice {
  /// Convert database entity to domain model
  PolarDevice toDomainModel() {
    return PolarDevice(
      deviceId: deviceId,
      name: name,
      firmwareVersion: firmwareVersion,
      batteryLevel: batteryLevel,
      connectionStatus: DeviceConnectionStatus.values.firstWhere(
        (status) => status.name == connectionStatus,
        orElse: () => DeviceConnectionStatus.disconnected,
      ),
      signalQuality: signalQuality,
      electrodeStatus: ElectrodeStatus.values.firstWhere(
        (status) => status.name == electrodeStatus,
        orElse: () => ElectrodeStatus.unknown,
      ),
      lastSeen: lastSeen,
    );
  }
}

extension MeasurementSessionMapper on MeasurementSession {
  /// Convert domain model to database companion
  db.MeasurementSessionsCompanion toCompanion() {
    return db.MeasurementSessionsCompanion.insert(
      sessionId: sessionId,
      deviceId: deviceId,
      startTime: startTime,
      endTime: Value(endTime),
      status: status.name,
      type: type.name,
      tags: Value(tags.isNotEmpty ? jsonEncode(tags) : null),
      notes: Value(notes),
    );
  }

  /// Update database companion with domain model
  db.MeasurementSessionsCompanion toUpdateCompanion() {
    return db.MeasurementSessionsCompanion(
      sessionId: Value(sessionId),
      deviceId: Value(deviceId),
      startTime: Value(startTime),
      endTime: Value(endTime),
      status: Value(status.name),
      type: Value(type.name),
      tags: Value(tags.isNotEmpty ? jsonEncode(tags) : null),
      notes: Value(notes),
      updatedAt: Value(DateTime.now()),
    );
  }
}

extension MeasurementSessionEntityMapper on db.MeasurementSession {
  /// Convert database entity to domain model
  MeasurementSession toDomainModel() {
    return MeasurementSession(
      sessionId: sessionId,
      deviceId: deviceId,
      startTime: startTime,
      endTime: endTime,
      status: SessionStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => SessionStatus.preparing,
      ),
      type: SessionType.values.firstWhere(
        (t) => t.name == type,
        orElse: () => SessionType.general,
      ),
      tags: tags != null ? List<String>.from(jsonDecode(tags!)) : [],
      notes: notes,
    );
  }
}

extension EcgSampleMapper on EcgSample {
  /// Convert domain model to database companion
  db.EcgSamplesCompanion toCompanion() {
    return db.EcgSamplesCompanion.insert(
      sessionId: sessionId,
      timestamp: timestamp,
      voltage: voltage,
      sequenceNumber: sequenceNumber,
      quality: Value(quality),
      isRPeak: Value(isRPeak),
      leadId: Value(leadId),
    );
  }
}

extension EcgSampleEntityMapper on db.EcgSample {
  /// Convert database entity to domain model
  EcgSample toDomainModel() {
    return EcgSample(
      sessionId: sessionId,
      timestamp: timestamp,
      voltage: voltage,
      sequenceNumber: sequenceNumber,
      quality: quality,
      isRPeak: isRPeak,
      leadId: leadId,
    );
  }
}

extension HeartRateSampleMapper on HeartRateSample {
  /// Convert domain model to database companion
  db.HeartRateSamplesCompanion toCompanion() {
    return db.HeartRateSamplesCompanion.insert(
      sessionId: sessionId,
      timestamp: timestamp,
      heartRate: heartRate,
      rrIntervals: Value(rrIntervals.isNotEmpty ? jsonEncode(rrIntervals) : null),
      contactDetected: contactDetected,
      quality: Value(quality),
      source: source.name,
    );
  }
}

extension HeartRateSampleEntityMapper on db.HeartRateSample {
  /// Convert database entity to domain model
  HeartRateSample toDomainModel() {
    return HeartRateSample(
      sessionId: sessionId,
      timestamp: timestamp,
      heartRate: heartRate,
      rrIntervals: rrIntervals != null 
          ? List<int>.from(jsonDecode(rrIntervals!)) 
          : [],
      contactDetected: contactDetected,
      quality: quality,
      source: HeartRateSource.values.firstWhere(
        (s) => s.name == source,
        orElse: () => HeartRateSource.ecg,
      ),
    );
  }
}

extension AnalysisResultMapper on AnalysisResult {
  /// Convert domain model to database companion
  db.AnalysisResultsCompanion toCompanion() {
    return db.AnalysisResultsCompanion.insert(
      analysisId: analysisId,
      sessionId: sessionId,
      analysisType: analysisType.name,
      analysisTimestamp: analysisTimestamp,
      algorithmVersion: algorithmVersion,
      status: status.name,
      data: jsonEncode(data.toJson()),
      confidence: Value(confidence),
      errorMessage: Value(errorMessage),
      processingTimeMs: Value(processingTimeMs),
    );
  }

  /// Update database companion with domain model
  db.AnalysisResultsCompanion toUpdateCompanion() {
    return db.AnalysisResultsCompanion(
      analysisId: Value(analysisId),
      sessionId: Value(sessionId),
      analysisType: Value(analysisType.name),
      analysisTimestamp: Value(analysisTimestamp),
      algorithmVersion: Value(algorithmVersion),
      status: Value(status.name),
      data: Value(jsonEncode(data.toJson())),
      confidence: Value(confidence),
      errorMessage: Value(errorMessage),
      processingTimeMs: Value(processingTimeMs),
      updatedAt: Value(DateTime.now()),
    );
  }
}

extension AnalysisResultEntityMapper on db.AnalysisResult {
  /// Convert database entity to domain model
  AnalysisResult toDomainModel() {
    return AnalysisResult(
      analysisId: analysisId,
      sessionId: sessionId,
      analysisType: AnalysisType.values.firstWhere(
        (t) => t.name == analysisType,
        orElse: () => AnalysisType.statistical,
      ),
      analysisTimestamp: analysisTimestamp,
      algorithmVersion: algorithmVersion,
      status: AnalysisStatus.values.firstWhere(
        (s) => s.name == status,
        orElse: () => AnalysisStatus.pending,
      ),
      data: AnalysisData.fromJson(jsonDecode(data)),
      confidence: confidence,
      errorMessage: errorMessage,
      processingTimeMs: processingTimeMs,
    );
  }
}

// Helper methods for decompressing ECG batch data
List<double> _decompressVoltageData(Uint8List data) {
  final buffer = ByteData.sublistView(data);
  final voltages = <double>[];
  for (int i = 0; i < data.length; i += 2) {
    voltages.add(buffer.getInt16(i) / 1000.0);
  }
  return voltages;
}

List<int> _decompressRPeakIndices(Uint8List? data) {
  if (data == null || data.isEmpty) return [];
  final buffer = ByteData.sublistView(data);
  final indices = <int>[];
  for (int i = 0; i < data.length; i += 4) {
    indices.add(buffer.getInt32(i));
  }
  return indices;
}

extension EcgSampleBatchEntityMapper on db.EcgSampleBatch {
  /// Convert database entity to domain batch model
  EcgSampleBatch toDomainBatch() {
    final voltages = _decompressVoltageData(voltagesData);
    final rPeak = _decompressRPeakIndices(rPeakIndices);

    final quality = qualityMetrics != null
        ? BatchQuality.fromJson(jsonDecode(qualityMetrics!))
        : null;

    return EcgSampleBatch(
      sessionId: sessionId,
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      samplingRate: samplingRate,
      voltages: voltages,
      rPeakIndices: rPeak,
      batchNumber: batchNumber,
      quality: quality,
    );
  }
}

extension HrvSampleMapper on HrvSample {
  db.HrvSamplesCompanion toCompanion() {
    return db.HrvSamplesCompanion.insert(
      sessionId: sessionId,
      timestamp: timestamp,
      rrIntervals: jsonEncode(rrIntervals),
      windowSeconds: windowSeconds,
      rmssd: Value(rmssd),
      sdnn: Value(sdnn),
      pnn50: Value(pnn50),
      meanRR: Value(meanRR),
      heartRate: Value(heartRate),
      stressIndex: Value(stressIndex),
    );
  }
}