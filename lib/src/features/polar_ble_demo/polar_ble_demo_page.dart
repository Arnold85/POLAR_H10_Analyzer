import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/polar_bridge/polar_bridge_plugin.dart';

/// Demo page to showcase the Polar BLE integration
class PolarBleDemoPage extends ConsumerStatefulWidget {
  const PolarBleDemoPage({super.key});

  @override
  ConsumerState<PolarBleDemoPage> createState() => _PolarBleDemoPageState();
}

class _PolarBleDemoPageState extends ConsumerState<PolarBleDemoPage> {
  final PolarBridge _polarBridge = PolarBridge.instance;
  
  PolarConnectionStatus _connectionStatus = PolarConnectionStatus.disconnected;
  List<PolarDevice> _discoveredDevices = [];
  PolarDevice? _connectedDevice;
  HeartRateSample? _latestHrSample;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializePolarBridge();
  }

  Future<void> _initializePolarBridge() async {
    try {
      await _polarBridge.initialize();
      
      // Listen to connection status
      _polarBridge.connectionStatusStream.listen((status) {
        if (mounted) {
          setState(() {
            _connectionStatus = status;
          });
        }
      });

      // Listen to device discovery
      _polarBridge.deviceDiscoveryStream.listen((device) {
        if (mounted) {
          setState(() {
            if (!_discoveredDevices.any((d) => d.deviceId == device.deviceId)) {
              _discoveredDevices.add(device);
            }
          });
        }
      });

      // Listen to heart rate data
      _polarBridge.heartRateStream.listen((sample) {
        if (mounted) {
          setState(() {
            _latestHrSample = sample;
          });
        }
      });

      setState(() {
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _requestPermissions() async {
    try {
      final granted = await _polarBridge.requestBluetoothPermissions();
      if (!granted) {
        setState(() {
          _error = 'Bluetooth permissions not granted';
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _startScan() async {
    try {
      setState(() {
        _discoveredDevices.clear();
        _error = null;
      });
      await _polarBridge.startDeviceScan();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _stopScan() async {
    try {
      await _polarBridge.stopDeviceScan();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _connectToDevice(PolarDevice device) async {
    try {
      await _polarBridge.connectToDevice(device.deviceId);
      setState(() {
        _connectedDevice = device;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _disconnect() async {
    try {
      await _polarBridge.disconnectFromDevice();
      setState(() {
        _connectedDevice = null;
        _latestHrSample = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _startHeartRateStream() async {
    try {
      await _polarBridge.startHeartRateStream();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _stopHeartRateStream() async {
    try {
      await _polarBridge.stopHeartRateStream();
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _enableMockMode() async {
    try {
      await _polarBridge.enableMockMode(enabled: true);
      setState(() {
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polar BLE Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Connection Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Status',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _getStatusIcon(),
                          color: _getStatusColor(),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _connectionStatus.displayName,
                          style: TextStyle(
                            color: _getStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _connectionStatus.description,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Error Display
            if (_error != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Control Buttons
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _requestPermissions,
                  child: const Text('Request Permissions'),
                ),
                ElevatedButton(
                  onPressed: _enableMockMode,
                  child: const Text('Enable Mock Mode'),
                ),
                ElevatedButton(
                  onPressed: _connectionStatus == PolarConnectionStatus.scanning
                      ? _stopScan
                      : _startScan,
                  child: Text(_connectionStatus == PolarConnectionStatus.scanning
                      ? 'Stop Scan'
                      : 'Start Scan'),
                ),
                if (_connectedDevice != null) ...[
                  ElevatedButton(
                    onPressed: _disconnect,
                    child: const Text('Disconnect'),
                  ),
                  ElevatedButton(
                    onPressed: _connectionStatus == PolarConnectionStatus.streaming
                        ? _stopHeartRateStream
                        : _startHeartRateStream,
                    child: Text(_connectionStatus == PolarConnectionStatus.streaming
                        ? 'Stop HR Stream'
                        : 'Start HR Stream'),
                  ),
                ],
              ],
            ),

            // Heart Rate Data
            if (_latestHrSample != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Latest Heart Rate',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_latestHrSample!.heartRate} BPM',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_latestHrSample!.rrIntervals.isNotEmpty)
                        Text(
                          'RR: ${_latestHrSample!.rrIntervals.join(", ")} ms',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      if (_latestHrSample!.contactStatus != null)
                        Text(
                          'Contact: ${_latestHrSample!.contactStatus! ? "Good" : "Poor"}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
            ],

            // Discovered Devices
            const SizedBox(height: 16),
            Text(
              'Discovered Devices (${_discoveredDevices.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _discoveredDevices.length,
                itemBuilder: (context, index) {
                  final device = _discoveredDevices[index];
                  final isConnected = _connectedDevice?.deviceId == device.deviceId;
                  
                  return Card(
                    color: isConnected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    child: ListTile(
                      leading: Icon(
                        Icons.bluetooth,
                        color: isConnected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      title: Text(device.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${device.deviceId}'),
                          if (device.rssi != null)
                            Text('RSSI: ${device.rssi} dBm'),
                        ],
                      ),
                      trailing: isConnected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : device.isConnectable
                              ? IconButton(
                                  icon: const Icon(Icons.connect_without_contact),
                                  onPressed: () => _connectToDevice(device),
                                )
                              : const Icon(Icons.block, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (_connectionStatus) {
      case PolarConnectionStatus.disconnected:
        return Icons.bluetooth_disabled;
      case PolarConnectionStatus.connecting:
        return Icons.bluetooth_searching;
      case PolarConnectionStatus.connected:
        return Icons.bluetooth_connected;
      case PolarConnectionStatus.streaming:
        return Icons.stream;
      case PolarConnectionStatus.error:
        return Icons.error;
      case PolarConnectionStatus.scanning:
        return Icons.radar;
    }
  }

  Color _getStatusColor() {
    switch (_connectionStatus) {
      case PolarConnectionStatus.disconnected:
        return Colors.grey;
      case PolarConnectionStatus.connecting:
        return Colors.orange;
      case PolarConnectionStatus.connected:
        return Colors.blue;
      case PolarConnectionStatus.streaming:
        return Colors.green;
      case PolarConnectionStatus.error:
        return Colors.red;
      case PolarConnectionStatus.scanning:
        return Colors.purple;
    }
  }
}