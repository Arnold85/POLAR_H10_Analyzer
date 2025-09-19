import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../domain/models/models.dart';
import '../../domain/repositories/repositories.dart';
import 'csv_export_service.dart';

/// Service for generating PDF reports from session data
class PdfReportService {
  final SessionRepository _sessionRepository;
  final SampleRepository _sampleRepository;
  final AnalysisRepository _analysisRepository;

  const PdfReportService(
    this._sessionRepository,
    this._sampleRepository,
    this._analysisRepository,
  );

  /// Generate comprehensive PDF report for a session
  Future<ExportResult> generateReport(
    String sessionId, {
    PdfReportOptions? options,
  }) async {
    try {
      final session = await _sessionRepository.getSession(sessionId);
      if (session == null) {
        throw ExportException('Session not found: $sessionId');
      }

      final reportOptions = options ?? const PdfReportOptions();
      final exportDir = await _createExportDirectory(sessionId);
      
      // Gather all data
      final sessionStats = await _sessionRepository.getSessionStatistics(sessionId);
      final analysisResults = await _analysisRepository.getAnalysisResults(sessionId);
      final analysisSummary = await _analysisRepository.getAnalysisSummary(sessionId);
      
      List<HeartRateSample>? hrSamples;
      List<HrvSample>? hrvSamples;
      
      if (reportOptions.includeCharts) {
        hrSamples = await _sampleRepository.getHeartRateSamples(
          sessionId,
          limit: 1000, // Limit for chart generation
        );
        
        hrvSamples = await _sampleRepository.getHrvSamples(
          sessionId,
          limit: 100,
        );
      }

      final pdfFile = await _generatePdfDocument(
        session,
        sessionStats,
        analysisResults,
        analysisSummary,
        exportDir,
        reportOptions,
        hrSamples: hrSamples,
        hrvSamples: hrvSamples,
      );

      return ExportResult(
        success: true,
        exportPath: pdfFile,
        files: [pdfFile],
        format: ExportFormat.pdf,
      );
    } catch (e) {
      return ExportResult(
        success: false,
        errorMessage: e.toString(),
        format: ExportFormat.pdf,
      );
    }
  }

  Future<Directory> _createExportDirectory(String sessionId) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final exportDir = Directory(p.join(
      documentsDir.path,
      'exports',
      'pdf',
    ));
    
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    
    return exportDir;
  }

  Future<String> _generatePdfDocument(
    MeasurementSession session,
    SessionStatistics sessionStats,
    List<AnalysisResult> analysisResults,
    AnalysisSummary analysisSummary,
    Directory exportDir,
    PdfReportOptions options, {
    List<HeartRateSample>? hrSamples,
    List<HrvSample>? hrvSamples,
  }) async {
    final pdf = pw.Document();

    // Cover page
    pdf.addPage(_buildCoverPage(session, sessionStats));

    // Session overview
    pdf.addPage(_buildSessionOverviewPage(session, sessionStats, analysisSummary));

    // Analysis results
    if (analysisResults.isNotEmpty && options.includeAnalysis) {
      pdf.addPage(_buildAnalysisPage(analysisResults));
    }

    // Heart rate charts
    if (hrSamples != null && hrSamples.isNotEmpty && options.includeCharts) {
      pdf.addPage(_buildHeartRateChartsPage(hrSamples));
    }

    // HRV analysis
    if (hrvSamples != null && hrvSamples.isNotEmpty && options.includeCharts) {
      pdf.addPage(_buildHrvAnalysisPage(hrvSamples));
    }

    // AI insights (if available)
    final aiInsights = _extractAiInsights(analysisResults);
    if (aiInsights.isNotEmpty && options.includeAiInsights) {
      pdf.addPage(_buildAiInsightsPage(aiInsights));
    }

    // Export metadata page
    if (options.includeMetadata) {
      pdf.addPage(_buildMetadataPage(session, sessionStats));
    }

    // Save PDF
    final fileName = 'polar_h10_report_${session.sessionId}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File(p.join(exportDir.path, fileName));
    await file.writeAsBytes(await pdf.save());
    
    return file.path;
  }

  pw.Page _buildCoverPage(MeasurementSession session, SessionStatistics stats) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Polar H10 Analysis Report',
                style: pw.TextStyle(fontSize: 32, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                'Session ID: ${session.sessionId}',
                style: pw.TextStyle(fontSize: 18),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Device: ${session.deviceId}',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Date: ${_formatDateTime(session.startTime)}',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Duration: ${_formatDuration(session.durationSeconds)}',
                style: pw.TextStyle(fontSize: 16),
              ),
              pw.SizedBox(height: 40),
              pw.Text(
                'Generated: ${_formatDateTime(DateTime.now())}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
              ),
            ],
          ),
        );
      },
    );
  }

  pw.Page _buildSessionOverviewPage(
    MeasurementSession session,
    SessionStatistics stats,
    AnalysisSummary summary,
  ) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Session Overview',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            _buildInfoTable([
              ['Session ID', session.sessionId],
              ['Device', session.deviceId],
              ['Type', session.type.name.toUpperCase()],
              ['Status', session.status.name.toUpperCase()],
              ['Start Time', _formatDateTime(session.startTime)],
              ['End Time', session.endTime != null ? _formatDateTime(session.endTime!) : 'Ongoing'],
              ['Duration', _formatDuration(session.durationSeconds)],
              ['Tags', session.tags.join(', ')],
            ]),
            pw.SizedBox(height: 30),
            pw.Text(
              'Data Statistics',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            _buildInfoTable([
              ['ECG Samples', stats.totalEcgSamples.toString()],
              ['Heart Rate Samples', stats.totalHeartRateSamples.toString()],
              ['Analysis Count', stats.analysisCount.toString()],
              ['Completed Analyses', summary.completedAnalyses.toString()],
              ['Average Confidence', summary.averageConfidence?.toStringAsFixed(1) ?? 'N/A'],
            ]),
            if (session.notes != null && session.notes!.isNotEmpty) ...[
              pw.SizedBox(height: 30),
              pw.Text(
                'Notes',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),
              pw.Text(session.notes!),
            ],
          ],
        );
      },
    );
  }

  pw.Page _buildAnalysisPage(List<AnalysisResult> results) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Analysis Results',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            ...results.take(5).map((result) => _buildAnalysisSection(result)),
          ],
        );
      },
    );
  }

  pw.Widget _buildAnalysisSection(AnalysisResult result) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            result.analysisType.name.toUpperCase(),
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Text('Status: ${result.status.name}'),
          pw.Text('Confidence: ${result.confidence ?? 'N/A'}%'),
          pw.Text('Algorithm: ${result.algorithmVersion}'),
          if (result.data.statistical != null) ...[
            pw.SizedBox(height: 10),
            pw.Text('Statistical Metrics:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Mean HR: ${result.data.statistical!.meanHeartRate.toStringAsFixed(1)} BPM'),
            pw.Text('Min HR: ${result.data.statistical!.minHeartRate} BPM'),
            pw.Text('Max HR: ${result.data.statistical!.maxHeartRate} BPM'),
          ],
          if (result.data.hrv != null) ...[
            pw.SizedBox(height: 10),
            pw.Text('HRV Metrics:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('RMSSD: ${result.data.hrv!.rmssd.toStringAsFixed(2)} ms'),
            pw.Text('SDNN: ${result.data.hrv!.sdnn.toStringAsFixed(2)} ms'),
            pw.Text('Stress Index: ${result.data.hrv!.stressIndex}'),
          ],
        ],
      ),
    );
  }

  pw.Page _buildHeartRateChartsPage(List<HeartRateSample> samples) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Heart Rate Analysis',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Heart Rate Trends',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              height: 200,
              child: pw.Text('Heart Rate Chart Placeholder\n(Chart generation would require additional chart library)'),
            ),
            pw.SizedBox(height: 30),
            pw.Text(
              'Statistics',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            _buildInfoTable([
              ['Average HR', '${samples.map((s) => s.heartRate).reduce((a, b) => a + b) / samples.length} BPM'],
              ['Min HR', '${samples.map((s) => s.heartRate).reduce((a, b) => a < b ? a : b)} BPM'],
              ['Max HR', '${samples.map((s) => s.heartRate).reduce((a, b) => a > b ? a : b)} BPM'],
              ['Sample Count', samples.length.toString()],
            ]),
          ],
        );
      },
    );
  }

  pw.Page _buildHrvAnalysisPage(List<HrvSample> samples) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        final avgRmssd = samples.where((s) => s.rmssd != null).map((s) => s.rmssd!).fold(0.0, (a, b) => a + b) / samples.length;
        final avgSdnn = samples.where((s) => s.sdnn != null).map((s) => s.sdnn!).fold(0.0, (a, b) => a + b) / samples.length;
        
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'HRV Analysis',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            _buildInfoTable([
              ['Average RMSSD', '${avgRmssd.toStringAsFixed(2)} ms'],
              ['Average SDNN', '${avgSdnn.toStringAsFixed(2)} ms'],
              ['HRV Sample Count', samples.length.toString()],
            ]),
          ],
        );
      },
    );
  }

  pw.Page _buildAiInsightsPage(List<AiInsights> insights) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'AI Insights',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            ...insights.map((insight) => _buildAiInsightSection(insight)),
          ],
        );
      },
    );
  }

  pw.Widget _buildAiInsightSection(AiInsights insight) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (insight.healthAssessment != null) ...[
            pw.Text('Health Assessment:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(insight.healthAssessment!),
            pw.SizedBox(height: 10),
          ],
          if (insight.stressInterpretation != null) ...[
            pw.Text('Stress Analysis:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text(insight.stressInterpretation!),
            pw.SizedBox(height: 10),
          ],
          if (insight.recommendations.isNotEmpty) ...[
            pw.Text('Recommendations:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ...insight.recommendations.map((rec) => pw.Text('• $rec')),
          ],
        ],
      ),
    );
  }

  pw.Page _buildMetadataPage(MeasurementSession session, SessionStatistics stats) {
    return pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Export Metadata',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 20),
            _buildInfoTable([
              ['Export Time', _formatDateTime(DateTime.now())],
              ['Report Generator', 'Polar H10 Analyzer v1.0.0'],
              ['Data Source', 'Local Database'],
              ['Session Duration', _formatDuration(session.durationSeconds)],
              ['Total Data Points', (stats.totalEcgSamples + stats.totalHeartRateSamples).toString()],
            ]),
          ],
        );
      },
    );
  }

  pw.Widget _buildInfoTable(List<List<String>> data) {
    return pw.Table(
      border: pw.TableBorder.all(),
      children: data.map((row) => pw.TableRow(
        children: row.map((cell) => pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(cell),
        )).toList(),
      )).toList(),
    );
  }

  List<AiInsights> _extractAiInsights(List<AnalysisResult> results) {
    return results
        .where((result) => result.data.aiInsights != null)
        .map((result) => result.data.aiInsights!)
        .toList();
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }
}

/// PDF report configuration options
class PdfReportOptions {
  final bool includeCharts;
  final bool includeAnalysis;
  final bool includeAiInsights;
  final bool includeMetadata;

  const PdfReportOptions({
    this.includeCharts = true,
    this.includeAnalysis = true,
    this.includeAiInsights = true,
    this.includeMetadata = true,
  });
}