import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/domain/models/hrv_metrics.dart';

void main() {
  group('HrvMetrics', () {
    test('should create HrvMetrics with required fields', () {
      final now = DateTime.now();
      final hrvMetrics = HrvMetrics(
        rmssd: 45.2,
        sdnn: 52.8,
        pnn50: 18.3,
        calculatedAt: now,
      );

      expect(hrvMetrics.rmssd, equals(45.2));
      expect(hrvMetrics.sdnn, equals(52.8));
      expect(hrvMetrics.pnn50, equals(18.3));
      expect(hrvMetrics.calculatedAt, equals(now));
      expect(hrvMetrics.meanRr, isNull);
      expect(hrvMetrics.totalBeats, isNull);
      expect(hrvMetrics.measurementDurationMs, isNull);
    });

    test('should create HrvMetrics with all fields', () {
      final now = DateTime.now();
      final hrvMetrics = HrvMetrics(
        rmssd: 45.2,
        sdnn: 52.8,
        pnn50: 18.3,
        calculatedAt: now,
        meanRr: 850.0,
        totalBeats: 120,
        measurementDurationMs: 60000,
      );

      expect(hrvMetrics.rmssd, equals(45.2));
      expect(hrvMetrics.sdnn, equals(52.8));
      expect(hrvMetrics.pnn50, equals(18.3));
      expect(hrvMetrics.calculatedAt, equals(now));
      expect(hrvMetrics.meanRr, equals(850.0));
      expect(hrvMetrics.totalBeats, equals(120));
      expect(hrvMetrics.measurementDurationMs, equals(60000));
    });

    test('should have proper equality comparison', () {
      final now = DateTime.now();
      final hrvMetrics1 = HrvMetrics(
        rmssd: 45.2,
        sdnn: 52.8,
        pnn50: 18.3,
        calculatedAt: now,
        meanRr: 850.0,
        totalBeats: 120,
      );

      final hrvMetrics2 = HrvMetrics(
        rmssd: 45.2,
        sdnn: 52.8,
        pnn50: 18.3,
        calculatedAt: now,
        meanRr: 850.0,
        totalBeats: 120,
      );

      final hrvMetrics3 = HrvMetrics(
        rmssd: 50.0,
        sdnn: 52.8,
        pnn50: 18.3,
        calculatedAt: now,
      );

      expect(hrvMetrics1, equals(hrvMetrics2));
      expect(hrvMetrics1.hashCode, equals(hrvMetrics2.hashCode));
      expect(hrvMetrics1, isNot(equals(hrvMetrics3)));
    });

    test('should have proper toString representation', () {
      final now = DateTime.now();
      final hrvMetrics = HrvMetrics(
        rmssd: 45.2,
        sdnn: 52.8,
        pnn50: 18.3,
        calculatedAt: now,
      );

      final stringRepresentation = hrvMetrics.toString();
      expect(stringRepresentation, contains('HrvMetrics'));
      expect(stringRepresentation, contains('45.2'));
      expect(stringRepresentation, contains('52.8'));
      expect(stringRepresentation, contains('18.3'));
    });

    test('should handle edge cases for numeric values', () {
      final now = DateTime.now();
      
      // Test with zero values
      final zeroMetrics = HrvMetrics(
        rmssd: 0.0,
        sdnn: 0.0,
        pnn50: 0.0,
        calculatedAt: now,
      );

      expect(zeroMetrics.rmssd, equals(0.0));
      expect(zeroMetrics.sdnn, equals(0.0));
      expect(zeroMetrics.pnn50, equals(0.0));

      // Test with high values
      final highMetrics = HrvMetrics(
        rmssd: 999.9,
        sdnn: 999.9,
        pnn50: 100.0,
        calculatedAt: now,
      );

      expect(highMetrics.rmssd, equals(999.9));
      expect(highMetrics.sdnn, equals(999.9));
      expect(highMetrics.pnn50, equals(100.0));
    });
  });
}