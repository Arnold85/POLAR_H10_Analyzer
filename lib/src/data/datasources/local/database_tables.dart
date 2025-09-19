import 'package:drift/drift.dart';

/// Polar devices table
class PolarDevices extends Table {
  TextColumn get deviceId => text().withLength(min: 1, max: 50)();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get firmwareVersion => text().nullable()();
  IntColumn get batteryLevel => integer().nullable()();
  TextColumn get connectionStatus => text().withLength(min: 1, max: 20)();
  IntColumn get signalQuality => integer().nullable()();
  TextColumn get electrodeStatus => text().withLength(min: 1, max: 20)();
  DateTimeColumn get lastSeen => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {deviceId};
}

/// Measurement sessions table
class MeasurementSessions extends Table {
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  TextColumn get deviceId => text().withLength(min: 1, max: 50)();
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime().nullable()();
  TextColumn get status => text().withLength(min: 1, max: 20)();
  TextColumn get type => text().withLength(min: 1, max: 20)();
  TextColumn get tags => text().nullable()(); // JSON array as string
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {sessionId};
}

/// ECG samples table for individual sample storage
class EcgSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get voltage => real()();
  IntColumn get sequenceNumber => integer()();
  IntColumn get quality => integer().nullable()();
  BoolColumn get isRPeak => boolean().withDefault(const Constant(false))();
  TextColumn get leadId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sessionId, sequenceNumber}
  ];
}

/// ECG sample batches table for efficient bulk storage
class EcgSampleBatches extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  DateTimeColumn get startTimestamp => dateTime()();
  DateTimeColumn get endTimestamp => dateTime()();
  RealColumn get samplingRate => real()();
  BlobColumn get voltagesData => blob()(); // Compressed voltage data
  BlobColumn get rPeakIndices => blob().nullable()(); // R-peak indices as bytes
  IntColumn get batchNumber => integer()();
  IntColumn get sampleCount => integer()();
  TextColumn get qualityMetrics => text().nullable()(); // JSON as string
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sessionId, batchNumber}
  ];
}

/// Heart rate samples table
class HeartRateSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get heartRate => integer()();
  TextColumn get rrIntervals => text().nullable()(); // JSON array as string
  BoolColumn get contactDetected => boolean()();
  IntColumn get quality => integer().nullable()();
  TextColumn get source => text().withLength(min: 1, max: 20)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// HRV samples table
class HrvSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get rrIntervals => text()(); // JSON array as string
  IntColumn get windowSeconds => integer()();
  RealColumn get rmssd => real().nullable()();
  RealColumn get sdnn => real().nullable()();
  RealColumn get pnn50 => real().nullable()();
  RealColumn get meanRR => real().nullable()();
  RealColumn get heartRate => real().nullable()();
  IntColumn get stressIndex => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Analysis results table
class AnalysisResults extends Table {
  TextColumn get analysisId => text().withLength(min: 1, max: 50)();
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  TextColumn get analysisType => text().withLength(min: 1, max: 30)();
  DateTimeColumn get analysisTimestamp => dateTime()();
  TextColumn get algorithmVersion => text().withLength(min: 1, max: 20)();
  TextColumn get status => text().withLength(min: 1, max: 20)();
  TextColumn get data => text()(); // JSON data as string
  IntColumn get confidence => integer().nullable()();
  TextColumn get errorMessage => text().nullable()();
  IntColumn get processingTimeMs => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {analysisId};
}

/// Export history table to track exports
class ExportHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get exportId => text().withLength(min: 1, max: 50)();
  TextColumn get sessionId => text().withLength(min: 1, max: 50)();
  TextColumn get exportType => text().withLength(min: 1, max: 20)(); // CSV, EDF, PDF
  TextColumn get filePath => text()();
  IntColumn get fileSizeBytes => integer()();
  DateTimeColumn get exportTimestamp => dateTime()();
  TextColumn get parameters => text().nullable()(); // Export parameters as JSON
  TextColumn get status => text().withLength(min: 1, max: 20)();
  TextColumn get errorMessage => text().nullable()();
}