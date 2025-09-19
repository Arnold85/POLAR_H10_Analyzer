import 'dart:convert';
import '../../domain/models/models.dart';
import '../datasources/local/app_database.dart';

/// Extension to convert database entities to domain models
extension PolarDeviceMapper on PolarDevice {
  /// Convert domain model to database companion
  PolarDevicesCompanion toCompanion() {
    return PolarDevicesCompanion.insert(
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
  PolarDevicesCompanion toUpdateCompanion() {
    return PolarDevicesCompanion(
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

extension PolarDeviceEntityMapper on PolarDevice {
  /// Convert database entity to domain model
  static PolarDevice fromEntity(PolarDevice entity) {
    return PolarDevice(
      deviceId: entity.deviceId,
      name: entity.name,
      firmwareVersion: entity.firmwareVersion,
      batteryLevel: entity.batteryLevel,
      connectionStatus: DeviceConnectionStatus.values.firstWhere(
        (status) => status.name == entity.connectionStatus,
        orElse: () => DeviceConnectionStatus.disconnected,
      ),
      signalQuality: entity.signalQuality,
      electrodeStatus: ElectrodeStatus.values.firstWhere(
        (status) => status.name == entity.electrodeStatus,
        orElse: () => ElectrodeStatus.unknown,
      ),
      lastSeen: entity.lastSeen,
    );
  }
}

extension MeasurementSessionMapper on MeasurementSession {
  /// Convert domain model to database companion
  MeasurementSessionsCompanion toCompanion() {
    return MeasurementSessionsCompanion.insert(
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
  MeasurementSessionsCompanion toUpdateCompanion() {
    return MeasurementSessionsCompanion(
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

extension MeasurementSessionEntityMapper on MeasurementSessionData {
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
  EcgSamplesCompanion toCompanion() {
    return EcgSamplesCompanion.insert(
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

extension EcgSampleEntityMapper on EcgSample {
  /// Convert database entity to domain model
  static EcgSample fromEntity(EcgSample entity) {
    return EcgSample(
      sessionId: entity.sessionId,
      timestamp: entity.timestamp,
      voltage: entity.voltage,
      sequenceNumber: entity.sequenceNumber,
      quality: entity.quality,
      isRPeak: entity.isRPeak,
      leadId: entity.leadId,
    );
  }
}

extension HeartRateSampleMapper on HeartRateSample {
  /// Convert domain model to database companion
  HeartRateSamplesCompanion toCompanion() {
    return HeartRateSamplesCompanion.insert(
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

extension HeartRateSampleEntityMapper on HeartRateSampleData {
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
  AnalysisResultsCompanion toCompanion() {
    return AnalysisResultsCompanion.insert(
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
  AnalysisResultsCompanion toUpdateCompanion() {
    return AnalysisResultsCompanion(
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

extension AnalysisResultEntityMapper on AnalysisResultData {
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