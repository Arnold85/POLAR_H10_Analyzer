import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:polar_bridge/polar_bridge.dart' as bridge;
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/app_strings.dart';
import '../../../domain/models/polar_device.dart';
import '../../../providers/data_providers.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/placeholder_card.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final List<PolarDevice> _discoveredDevices = [];
  StreamSubscription<PolarDevice>? _scanSub;
  bool _isScanning = false;
  final List<Map<String, dynamic>> _rawPluginEvents = [];
  Timer? _scanTimeoutTimer;
  bool _isBluetoothEnabled = false;

  @override
  void initState() {
    super.initState();
    _scanSub = ref.read(bleServiceProvider).scanResults.listen((d) {
      if (mounted) {
        setState(() {
          // avoid duplicates
          if (!_discoveredDevices.any((x) => x.deviceId == d.deviceId)) {
            _discoveredDevices.add(d);
          }
        });
      }
    });
    // Also subscribe to raw plugin events for debugging
    // Subscribe to public events stream from the plugin for debugging
    bridge.PolarBridge.instance.events.listen((e) {
      if (mounted && e is Map) {
        setState(() {
          _rawPluginEvents.insert(0, Map<String, dynamic>.from(e));
          if (_rawPluginEvents.length > 20) _rawPluginEvents.removeLast();
        });
      }
    });
    // Query adapter state once
    bridge.PolarBridge.instance.isBluetoothEnabled().then((v) {
      if (mounted) setState(() => _isBluetoothEnabled = v);
    });
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    // Ensure we stop scanning when the widget is disposed.
    if (_isScanning) {
      ref.read(bleServiceProvider).stopScan().catchError((e) {
        // Log or handle error if necessary, but don't prevent disposal.
        debugPrint('Error stopping scan on dispose: $e');
      });
    }
    super.dispose();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        children: [
          const PageHeader(
            icon: Icons.monitor_heart,
            title: AppStrings.liveMonitoringTitle,
            description: AppStrings.liveMonitoringDescription,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.connectionStatusTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _isScanning
                            ? null
                            : () async {
                                // Check Bluetooth adapter state first
                                final btEnabled = await bridge
                                    .PolarBridge
                                    .instance
                                    .isBluetoothEnabled();
                                if (!btEnabled) {
                                  _showSnackBar(
                                    'Bluetooth is off — please enable it in system settings.',
                                  );
                                  setState(() => _isBluetoothEnabled = false);
                                  return;
                                }

                                // Request runtime permissions (Android 12+)
                                final scanPerm = await Permission.bluetoothScan
                                    .request();
                                final connPerm = await Permission
                                    .bluetoothConnect
                                    .request();
                                if (!scanPerm.isGranted ||
                                    !connPerm.isGranted) {
                                  _showSnackBar(
                                    'Bluetooth permissions are required to scan',
                                  );
                                  return;
                                }
                                try {
                                  setState(() {
                                    _discoveredDevices.clear();
                                  });
                                  await ref
                                      .read(bleServiceProvider)
                                      .initialize();
                                  await ref
                                      .read(bleServiceProvider)
                                      .startScan();
                                  setState(() {
                                    _isScanning = true;
                                    // reset timeout
                                    _scanTimeoutTimer?.cancel();
                                    _scanTimeoutTimer = Timer(
                                      const Duration(seconds: 8),
                                      () {
                                        if (mounted &&
                                            _isScanning &&
                                            _discoveredDevices.isEmpty) {
                                          _showSnackBar(
                                            'No devices found — is Bluetooth enabled?',
                                          );
                                        }
                                      },
                                    );
                                  });
                                  _showSnackBar('Scan started');
                                } catch (e) {
                                  _showSnackBar('Start scan failed: $e');
                                }
                              },
                        child: const Text('Start Scan'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: !_isScanning
                            ? null
                            : () async {
                                try {
                                  await ref.read(bleServiceProvider).stopScan();
                                  setState(() {
                                    _isScanning = false;
                                    _scanTimeoutTimer?.cancel();
                                  });
                                  _showSnackBar('Scan stopped');
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
                    height: 180,
                    child: _discoveredDevices.isEmpty
                        ? const Center(
                            child: Text(
                              'No devices found yet. Press "Start Scan".',
                            ),
                          )
                        : ListView.builder(
                            itemCount: _discoveredDevices.length,
                            itemBuilder: (context, i) {
                              final dev = _discoveredDevices[i];
                              return ListTile(
                                title: Text(dev.name),
                                subtitle: Text(dev.deviceId),
                                trailing: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(bleServiceProvider)
                                          .connect(dev.deviceId);
                                      _showSnackBar(
                                        'Connecting to ${dev.name}...',
                                      );
                                    } catch (e) {
                                      _showSnackBar(
                                        'Connection to ${dev.name} failed: $e',
                                      );
                                    }
                                  },
                                  child: const Text('Connect'),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  // Bluetooth adapter state indicator
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Bluetooth Adapter',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Row(
                            children: [
                              Icon(
                                _isBluetoothEnabled
                                    ? Icons.bluetooth
                                    : Icons.bluetooth_disabled,
                                color: _isBluetoothEnabled
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Text(_isBluetoothEnabled ? 'On' : 'Off'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug: Raw plugin events',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: _rawPluginEvents.isEmpty
                        ? const Center(child: Text('No raw events yet'))
                        : ListView.builder(
                            itemCount: _rawPluginEvents.length,
                            itemBuilder: (context, i) {
                              final evt = _rawPluginEvents[i];
                              return ListTile(
                                dense: true,
                                title: Text(evt['type']?.toString() ?? 'event'),
                                subtitle: Text(
                                  evt.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap Start Scan and watch this panel for plugin-reported events.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const PlaceholderCard(
            icon: Icons.show_chart,
            title: AppStrings.signalPreviewTitle,
            description: AppStrings.signalPreviewDescription,
          ),
        ],
      ),
    );
  }
}
