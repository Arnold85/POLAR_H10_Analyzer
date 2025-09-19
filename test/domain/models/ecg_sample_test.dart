import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/domain/models/ecg_sample.dart';

void main() {
  group('EcgSample', () {
    test('should create a valid EcgSample instance', () {
      final timestamp = DateTime.now();
      final sample = EcgSample(
        sessionId: 'SESSION123',
        timestamp: timestamp,
        voltage: 1.25,
        sequenceNumber: 100,
        quality: 95,
        isRPeak: true,
        leadId: 'LEAD_I',
      );

      expect(sample.sessionId, 'SESSION123');
      expect(sample.timestamp, timestamp);
      expect(sample.voltage, 1.25);
      expect(sample.sequenceNumber, 100);
      expect(sample.quality, 95);
      expect(sample.isRPeak, true);
      expect(sample.leadId, 'LEAD_I');
    });

    test('should support copyWith functionality', () {
      final originalSample = EcgSample(
        sessionId: 'SESSION123',
        timestamp: DateTime.now(),
        voltage: 1.0,
        sequenceNumber: 100,
        isRPeak: false,
      );

      final updatedSample = originalSample.copyWith(
        voltage: 2.5,
        isRPeak: true,
        quality: 90,
      );

      expect(updatedSample.sessionId, originalSample.sessionId);
      expect(updatedSample.sequenceNumber, originalSample.sequenceNumber);
      expect(updatedSample.voltage, 2.5);
      expect(updatedSample.isRPeak, true);
      expect(updatedSample.quality, 90);
    });

    test('should implement equality correctly', () {
      final timestamp = DateTime.now();
      
      final sample1 = EcgSample(
        sessionId: 'SESSION123',
        timestamp: timestamp,
        voltage: 1.0,
        sequenceNumber: 100,
      );

      final sample2 = EcgSample(
        sessionId: 'SESSION123',
        timestamp: timestamp.add(const Duration(seconds: 1)),
        voltage: 2.0,
        sequenceNumber: 100,
      );

      final sample3 = EcgSample(
        sessionId: 'SESSION123',
        timestamp: timestamp,
        voltage: 1.0,
        sequenceNumber: 101,
      );

      expect(sample1, equals(sample2)); // Same sessionId and sequenceNumber
      expect(sample1, isNot(equals(sample3))); // Different sequenceNumber
    });

    test('should handle JSON serialization', () {
      final timestamp = DateTime.parse('2023-01-01T12:00:00Z');
      final sample = EcgSample(
        sessionId: 'SESSION123',
        timestamp: timestamp,
        voltage: 1.25,
        sequenceNumber: 100,
        quality: 95,
        isRPeak: true,
      );

      final json = sample.toJson();
      expect(json['sessionId'], 'SESSION123');
      expect(json['voltage'], 1.25);
      expect(json['sequenceNumber'], 100);
      expect(json['isRPeak'], true);

      final sampleFromJson = EcgSample.fromJson(json);
      expect(sampleFromJson.sessionId, sample.sessionId);
      expect(sampleFromJson.voltage, sample.voltage);
      expect(sampleFromJson.isRPeak, sample.isRPeak);
    });
  });

  group('EcgSampleBatch', () {
    test('should create a valid EcgSampleBatch instance', () {
      final startTime = DateTime.now();
      final endTime = startTime.add(const Duration(seconds: 1));
      
      final batch = EcgSampleBatch(
        sessionId: 'SESSION123',
        startTimestamp: startTime,
        endTimestamp: endTime,
        samplingRate: 130.0,
        voltages: [1.0, 1.5, 2.0, 1.8, 1.2],
        rPeakIndices: [1, 3],
        batchNumber: 1,
      );

      expect(batch.sessionId, 'SESSION123');
      expect(batch.samplingRate, 130.0);
      expect(batch.voltages.length, 5);
      expect(batch.rPeakIndices, [1, 3]);
      expect(batch.batchNumber, 1);
    });

    test('should convert to individual samples correctly', () {
      final startTime = DateTime.parse('2023-01-01T12:00:00Z');
      final endTime = startTime.add(const Duration(seconds: 1));
      
      final batch = EcgSampleBatch(
        sessionId: 'SESSION123',
        startTimestamp: startTime,
        endTimestamp: endTime,
        samplingRate: 5.0, // 5 Hz for easy calculation
        voltages: [1.0, 1.5, 2.0, 1.8, 1.2],
        rPeakIndices: [1, 3],
        batchNumber: 0,
      );

      final samples = batch.toSamples();
      
      expect(samples.length, 5);
      expect(samples[0].voltage, 1.0);
      expect(samples[1].voltage, 1.5);
      expect(samples[1].isRPeak, true); // Index 1 is R-peak
      expect(samples[2].isRPeak, false);
      expect(samples[3].isRPeak, true); // Index 3 is R-peak
      expect(samples[4].isRPeak, false);
      
      // Check sequence numbers
      expect(samples[0].sequenceNumber, 0);
      expect(samples[1].sequenceNumber, 1);
      expect(samples[4].sequenceNumber, 4);
    });

    test('should handle JSON serialization', () {
      final startTime = DateTime.parse('2023-01-01T12:00:00Z');
      final endTime = startTime.add(const Duration(seconds: 1));
      
      final quality = BatchQuality(
        averageQuality: 90,
        artifactCount: 2,
        snr: 15.5,
      );
      
      final batch = EcgSampleBatch(
        sessionId: 'SESSION123',
        startTimestamp: startTime,
        endTimestamp: endTime,
        samplingRate: 130.0,
        voltages: [1.0, 1.5, 2.0],
        rPeakIndices: [1],
        batchNumber: 1,
        quality: quality,
      );

      final json = batch.toJson();
      expect(json['sessionId'], 'SESSION123');
      expect(json['samplingRate'], 130.0);
      expect(json['batchNumber'], 1);

      final batchFromJson = EcgSampleBatch.fromJson(json);
      expect(batchFromJson.sessionId, batch.sessionId);
      expect(batchFromJson.samplingRate, batch.samplingRate);
      expect(batchFromJson.voltages, batch.voltages);
    });
  });

  group('BatchQuality', () {
    test('should create a valid BatchQuality instance', () {
      final quality = BatchQuality(
        averageQuality: 85,
        snr: 12.5,
        artifactCount: 3,
        baselineWander: 0.02,
      );

      expect(quality.averageQuality, 85);
      expect(quality.snr, 12.5);
      expect(quality.artifactCount, 3);
      expect(quality.baselineWander, 0.02);
    });

    test('should handle JSON serialization', () {
      final quality = BatchQuality(
        averageQuality: 85,
        snr: 12.5,
        artifactCount: 3,
      );

      final json = quality.toJson();
      expect(json['averageQuality'], 85);
      expect(json['snr'], 12.5);
      expect(json['artifactCount'], 3);

      final qualityFromJson = BatchQuality.fromJson(json);
      expect(qualityFromJson.averageQuality, quality.averageQuality);
      expect(qualityFromJson.snr, quality.snr);
      expect(qualityFromJson.artifactCount, quality.artifactCount);
    });
  });
}