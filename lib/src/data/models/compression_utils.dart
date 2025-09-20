import 'dart:typed_data';

/// Utilities for simple compression/decompression of ECG batch data.
/// These functions are intentionally public so multiple files can reuse them.

Uint8List compressVoltageData(List<double> voltages) {
  if (voltages.isEmpty) return Uint8List(0);
  final buffer = ByteData(voltages.length * 2);
  for (int i = 0; i < voltages.length; i++) {
    buffer.setInt16(i * 2, (voltages[i] * 1000).round());
  }
  return buffer.buffer.asUint8List();
}

List<double> decompressVoltageData(Uint8List? data) {
  if (data == null || data.isEmpty) return <double>[];
  final buffer = ByteData.sublistView(data);
  final voltages = <double>[];
  for (int i = 0; i < data.length; i += 2) {
    voltages.add(buffer.getInt16(i) / 1000.0);
  }
  return voltages;
}

Uint8List compressRPeakIndices(List<int> indices) {
  if (indices.isEmpty) return Uint8List(0);
  final buffer = ByteData(indices.length * 4);
  for (int i = 0; i < indices.length; i++) {
    buffer.setInt32(i * 4, indices[i]);
  }
  return buffer.buffer.asUint8List();
}

List<int> decompressRPeakIndices(Uint8List? data) {
  if (data == null || data.isEmpty) return <int>[];
  final buffer = ByteData.sublistView(data);
  final indices = <int>[];
  for (int i = 0; i < data.length; i += 4) {
    indices.add(buffer.getInt32(i));
  }
  return indices;
}
