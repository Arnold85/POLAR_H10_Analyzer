import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import '../../domain/models/models.dart';
import '../../providers/data_providers.dart';
// ...existing imports...

/// Example widget demonstrating the data layer integration
class DataLayerExample extends ConsumerStatefulWidget {
  const DataLayerExample({super.key});

  @override
  ConsumerState<DataLayerExample> createState() => _DataLayerExampleState();
}

class _DataLayerExampleState extends ConsumerState<DataLayerExample> {
  String? _currentSessionId;
  bool _isRecording = false;
  final List<PolarDevice> _discoveredDevices = [];
  StreamSubscription<PolarDevice>? _scanSub;

  @override
  Widget build(BuildContext context) {
    final dataService = ref.watch(dataServiceProvider);

    // Start listening to scan results once when widget builds
    _scanSub ??= ref.read(bleServiceProvider).scanResults.listen((d) {
      setState(() {
        // avoid duplicates
        if (!_discoveredDevices.any((x) => x.deviceId == d.deviceId))
          _discoveredDevices.add(d);
      });
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Data Layer Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Management',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _isRecording
                              ? null
                              : () => _startSession(),
                          child: const Text('Start Session'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: !_isRecording || _currentSessionId == null
                              ? null
                              : () => _stopSession(),
                          child: const Text('Stop Session'),
                        ),
                      ],
                    ),
                    if (_currentSessionId != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Current Session: $_currentSessionId',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Status: ${_isRecording ? "Recording" : "Stopped"}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BLE Controls',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await ref.read(bleServiceProvider).initialize();
                              await ref.read(bleServiceProvider).startScan();
                              _showSnackBar('Started scan');
                            } catch (e) {
                              _showSnackBar('Start scan failed: $e');
                            }
                          },
                          child: const Text('Start Scan'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await ref.read(bleServiceProvider).stopScan();
                              _showSnackBar('Stopped scan');
                            } catch (e) {
                              _showSnackBar('Stop scan failed: $e');
                            }
                          },
                          child: const Text('Stop Scan'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Discovered devices',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 160,
                      child: _discoveredDevices.isEmpty
                          ? const Text('No devices yet')
                          : ListView.builder(
                              itemCount: _discoveredDevices.length,
                              itemBuilder: (context, i) {
                                final dev = _discoveredDevices[i];
                                return ListTile(
                                  title: Text(dev.name),
                                  subtitle: Text(dev.deviceId),
                                  trailing: ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(bleServiceProvider)
                                          .connect(dev.deviceId);
                                      _showSnackBar(
                                        'Connecting to ${dev.name}',
                                      );
                                    },
                                    child: const Text('Connect'),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Simulation',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _currentSessionId == null
                              ? null
                              : () => _simulateEcgData(),
                          child: const Text('Simulate ECG'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _currentSessionId == null
                              ? null
                              : () => _simulateHeartRateData(),
                          child: const Text('Simulate HR'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data Export',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _currentSessionId == null
                              ? null
                              : () => _exportCsv(),
                          child: const Text('Export CSV'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _currentSessionId == null
                              ? null
                              : () => _exportPdf(),
                          child: const Text('Export PDF'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Sessions',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: FutureBuilder<List<MeasurementSession>>(
                          future: dataService.sessionRepository
                              .getRecentSessions(10),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            final sessions = snapshot.data ?? [];

                            if (sessions.isEmpty) {
                              return const Center(
                                child: Text('No sessions yet'),
                              );
                            }

                            return ListView.builder(
                              itemCount: sessions.length,
                              itemBuilder: (context, index) {
                                final session = sessions[index];
                                return ListTile(
                                  title: Text('Session ${session.sessionId}'),
                                  subtitle: Text(
                                    'Type: ${session.type.name} | Status: ${session.status.name}',
                                  ),
                                  trailing: Text('${session.durationSeconds}s'),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startSession() async {
    final dataService = ref.read(dataServiceProvider);

    // Create a new device if needed
    final device = PolarDevice(
      deviceId: 'DEMO_DEVICE_001',
      name: 'Demo Polar H10',
      connectionStatus: DeviceConnectionStatus.connected,
      electrodeStatus: ElectrodeStatus.good,
      lastSeen: DateTime.now(),
    );

    await dataService.deviceRepository.saveDevice(device);

    // Create a new session
    final sessionId = const Uuid().v4();
    final session = MeasurementSession(
      sessionId: sessionId,
      deviceId: device.deviceId,
      startTime: DateTime.now(),
      status: SessionStatus.recording,
      type: SessionType.general,
      tags: ['demo', 'test'],
      notes: 'Demo session created from data layer example',
    );

    await dataService.sessionRepository.createSession(session);

    setState(() {
      _currentSessionId = sessionId;
      _isRecording = true;
    });

    _showSnackBar('Session started successfully');
  }

  Future<void> _stopSession() async {
    if (_currentSessionId == null) return;

    final dataService = ref.read(dataServiceProvider);
    final session = await dataService.sessionRepository.getSession(
      _currentSessionId!,
    );

    if (session != null) {
      final updatedSession = session.copyWith(
        endTime: DateTime.now(),
        status: SessionStatus.completed,
      );

      await dataService.sessionRepository.updateSession(updatedSession);

      // Flush any buffered data
      await dataService.bufferingService.flushAll();

      setState(() {
        _isRecording = false;
      });

      _showSnackBar('Session stopped successfully');
    }
  }

  Future<void> _simulateEcgData() async {
    if (_currentSessionId == null) return;

    final dataService = ref.read(dataServiceProvider);
    final samples = <EcgSample>[];

    // Generate 100 sample ECG data points
    for (int i = 0; i < 100; i++) {
      final sample = EcgSample(
        sessionId: _currentSessionId!,
        timestamp: DateTime.now().add(Duration(milliseconds: i * 8)), // ~125 Hz
        voltage: _generateEcgVoltage(i),
        sequenceNumber: i,
        quality: 90 + (i % 10),
        isRPeak: i % 20 == 0, // R-peak every 20 samples (~6 BPM)
      );
      samples.add(sample);
    }

    // Add to buffer (will be automatically flushed)
    for (final sample in samples) {
      dataService.bufferingService.addEcgSample(sample);
    }

    _showSnackBar('Simulated ${samples.length} ECG samples');
  }

  Future<void> _simulateHeartRateData() async {
    if (_currentSessionId == null) return;

    final dataService = ref.read(dataServiceProvider);
    final samples = <HeartRateSample>[];

    // Generate 10 heart rate samples
    for (int i = 0; i < 10; i++) {
      final sample = HeartRateSample(
        sessionId: _currentSessionId!,
        timestamp: DateTime.now().add(Duration(seconds: i)),
        heartRate: 70 + (i % 20), // 70-89 BPM
        rrIntervals: [800, 850, 820, 840], // RR intervals in ms
        contactDetected: true,
        quality: 95,
        source: HeartRateSource.chestStrap,
      );
      samples.add(sample);
    }

    // Add to buffer
    for (final sample in samples) {
      dataService.bufferingService.addHeartRateSample(sample);
    }

    _showSnackBar('Simulated ${samples.length} HR samples');
  }

  Future<void> _exportCsv() async {
    if (_currentSessionId == null) return;
    try {
      final result = await ref
          .read(exportServiceProvider)
          .csvExportService
          .exportSession(_currentSessionId!);

      if (result.success) {
        _showSnackBar('CSV export successful: ${result.files.length} files');
      } else {
        _showSnackBar('CSV export failed: ${result.errorMessage}');
      }
    } catch (e) {
      _showSnackBar('CSV export error: $e');
    }
  }

  Future<void> _exportPdf() async {
    if (_currentSessionId == null) return;
    try {
      final result = await ref
          .read(exportServiceProvider)
          .pdfReportService
          .generateReport(_currentSessionId!);

      if (result.success) {
        _showSnackBar('PDF export successful');
      } else {
        _showSnackBar('PDF export failed: ${result.errorMessage}');
      }
    } catch (e) {
      _showSnackBar('PDF export error: $e');
    }
  }

  double _generateEcgVoltage(int index) {
    // Simple sine wave with some noise to simulate ECG
    final base = math.sin(index * 0.1) * 0.5;
    final noise = (math.Random().nextDouble() - 0.5) * 0.1;
    return base + noise;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
