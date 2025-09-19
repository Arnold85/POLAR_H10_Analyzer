import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/local/app_database.dart';
import '../data/repositories/repositories.dart';
import '../domain/repositories/repositories.dart';
import '../services/export/exports.dart';
import '../services/background/background.dart';

/// Database provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// Repository providers
final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftDeviceRepository(database);
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftSessionRepository(database);
});

final sampleRepositoryProvider = Provider<SampleRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftSampleRepository(database);
});

final analysisRepositoryProvider = Provider<AnalysisRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftAnalysisRepository(database);
});

/// Export service providers
final csvExportServiceProvider = Provider<CsvExportService>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final sampleRepo = ref.watch(sampleRepositoryProvider);
  final analysisRepo = ref.watch(analysisRepositoryProvider);
  return CsvExportService(sessionRepo, sampleRepo, analysisRepo);
});

final edfExportServiceProvider = Provider<EdfExportService>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final sampleRepo = ref.watch(sampleRepositoryProvider);
  return EdfExportService(sessionRepo, sampleRepo);
});

final pdfReportServiceProvider = Provider<PdfReportService>((ref) {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final sampleRepo = ref.watch(sampleRepositoryProvider);
  final analysisRepo = ref.watch(analysisRepositoryProvider);
  return PdfReportService(sessionRepo, sampleRepo, analysisRepo);
});

/// Background service providers
final dataBufferingServiceProvider = Provider<DataBufferingService>((ref) {
  final sampleRepo = ref.watch(sampleRepositoryProvider);
  return DataBufferingService(sampleRepo);
});

final batchStorageServiceProvider = Provider<BatchStorageService>((ref) {
  final sampleRepo = ref.watch(sampleRepositoryProvider);
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  return BatchStorageService(sampleRepo, sessionRepo);
});

/// Combined data service provider for convenience
final dataServiceProvider = Provider<DataService>((ref) {
  return DataService(
    deviceRepository: ref.watch(deviceRepositoryProvider),
    sessionRepository: ref.watch(sessionRepositoryProvider),
    sampleRepository: ref.watch(sampleRepositoryProvider),
    analysisRepository: ref.watch(analysisRepositoryProvider),
    bufferingService: ref.watch(dataBufferingServiceProvider),
    batchStorageService: ref.watch(batchStorageServiceProvider),
  );
});

/// Combined export service provider for convenience
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService(
    csvExportService: ref.watch(csvExportServiceProvider),
    edfExportService: ref.watch(edfExportServiceProvider),
    pdfReportService: ref.watch(pdfReportServiceProvider),
  );
});

/// Convenience wrapper for all data-related operations
class DataService {
  final DeviceRepository deviceRepository;
  final SessionRepository sessionRepository;
  final SampleRepository sampleRepository;
  final AnalysisRepository analysisRepository;
  final DataBufferingService bufferingService;
  final BatchStorageService batchStorageService;

  const DataService({
    required this.deviceRepository,
    required this.sessionRepository,
    required this.sampleRepository,
    required this.analysisRepository,
    required this.bufferingService,
    required this.batchStorageService,
  });
}

/// Convenience wrapper for all export-related operations
class ExportService {
  final CsvExportService csvExportService;
  final EdfExportService edfExportService;
  final PdfReportService pdfReportService;

  const ExportService({
    required this.csvExportService,
    required this.edfExportService,
    required this.pdfReportService,
  });

  /// Export session in multiple formats
  Future<MultiFormatExportResult> exportSessionAllFormats(
    String sessionId,
  ) async {
    final results = await Future.wait([
      csvExportService.exportSession(sessionId),
      edfExportService.exportSession(sessionId),
      pdfReportService.generateReport(sessionId),
    ]);

    return MultiFormatExportResult(
      csvResult: results[0],
      edfResult: results[1],
      pdfResult: results[2],
    );
  }
}

/// Multi-format export result
class MultiFormatExportResult {
  final ExportResult csvResult;
  final ExportResult edfResult;
  final ExportResult pdfResult;

  const MultiFormatExportResult({
    required this.csvResult,
    required this.edfResult,
    required this.pdfResult,
  });

  bool get allSuccessful => 
      csvResult.success && edfResult.success && pdfResult.success;

  List<String> get allFiles => [
    ...csvResult.files,
    ...edfResult.files,
    ...pdfResult.files,
  ];

  List<String> get errors => [
    if (csvResult.errorMessage != null) 'CSV: ${csvResult.errorMessage}',
    if (edfResult.errorMessage != null) 'EDF: ${edfResult.errorMessage}',
    if (pdfResult.errorMessage != null) 'PDF: ${pdfResult.errorMessage}',
  ];
}