import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/domain/models/heart_rate_analysis.dart';

void main() {
  group('HeartRateAnalysis', () {
    test('should create HeartRateAnalysis with required fields', () {
      final now = DateTime.now();
      final analysis = HeartRateAnalysis(
        restingHeartRate: 65,
        maxHeartRate: 190,
        currentHeartRate: 85,
        analyzedAt: now,
      );

      expect(analysis.restingHeartRate, equals(65));
      expect(analysis.maxHeartRate, equals(190));
      expect(analysis.currentHeartRate, equals(85));
      expect(analysis.analyzedAt, equals(now));
      expect(analysis.minHeartRate, isNull);
      expect(analysis.averageHeartRate, isNull);
      expect(analysis.heartRateZone, isNull);
    });

    test('should calculate heart rate reserve correctly', () {
      final analysis = HeartRateAnalysis(
        restingHeartRate: 60,
        maxHeartRate: 180,
        currentHeartRate: 120,
        analyzedAt: DateTime.now(),
      );

      expect(analysis.heartRateReserve, equals(120)); // 180 - 60
    });

    test('should calculate percentage HRR correctly', () {
      final analysis = HeartRateAnalysis(
        restingHeartRate: 60,
        maxHeartRate: 180,
        currentHeartRate: 120,
        analyzedAt: DateTime.now(),
      );

      // (120 - 60) / (180 - 60) * 100 = 60 / 120 * 100 = 50%
      expect(analysis.percentageHrr, equals(50.0));
    });

    test('should create complete HeartRateAnalysis with all fields', () {
      final now = DateTime.now();
      final analysis = HeartRateAnalysis(
        restingHeartRate: 65,
        maxHeartRate: 190,
        currentHeartRate: 85,
        analyzedAt: now,
        minHeartRate: 58,
        averageHeartRate: 78.5,
        heartRateZone: HeartRateZone.zone2,
      );

      expect(analysis.restingHeartRate, equals(65));
      expect(analysis.maxHeartRate, equals(190));
      expect(analysis.currentHeartRate, equals(85));
      expect(analysis.analyzedAt, equals(now));
      expect(analysis.minHeartRate, equals(58));
      expect(analysis.averageHeartRate, equals(78.5));
      expect(analysis.heartRateZone, equals(HeartRateZone.zone2));
    });

    test('should have proper equality comparison', () {
      final now = DateTime.now();
      final analysis1 = HeartRateAnalysis(
        restingHeartRate: 65,
        maxHeartRate: 190,
        currentHeartRate: 85,
        analyzedAt: now,
      );

      final analysis2 = HeartRateAnalysis(
        restingHeartRate: 65,
        maxHeartRate: 190,
        currentHeartRate: 85,
        analyzedAt: now,
      );

      final analysis3 = HeartRateAnalysis(
        restingHeartRate: 70,
        maxHeartRate: 190,
        currentHeartRate: 85,
        analyzedAt: now,
      );

      expect(analysis1, equals(analysis2));
      expect(analysis1.hashCode, equals(analysis2.hashCode));
      expect(analysis1, isNot(equals(analysis3)));
    });
  });

  group('HeartRateZone', () {
    test('should have correct zone names', () {
      expect(HeartRateZone.zone1.name, equals('Zone 1 - Active Recovery'));
      expect(HeartRateZone.zone2.name, equals('Zone 2 - Aerobic Base'));
      expect(HeartRateZone.zone3.name, equals('Zone 3 - Aerobic'));
      expect(HeartRateZone.zone4.name, equals('Zone 4 - Lactate Threshold'));
      expect(HeartRateZone.zone5.name, equals('Zone 5 - Neuromuscular Power'));
    });

    test('should have correct zone descriptions', () {
      expect(HeartRateZone.zone1.description, contains('50-60% HRR'));
      expect(HeartRateZone.zone2.description, contains('60-70% HRR'));
      expect(HeartRateZone.zone3.description, contains('70-80% HRR'));
      expect(HeartRateZone.zone4.description, contains('80-90% HRR'));
      expect(HeartRateZone.zone5.description, contains('90-100% HRR'));
    });

    test('should cover all heart rate zones', () {
      final zones = HeartRateZone.values;
      expect(zones.length, equals(5));
      expect(zones, contains(HeartRateZone.zone1));
      expect(zones, contains(HeartRateZone.zone2));
      expect(zones, contains(HeartRateZone.zone3));
      expect(zones, contains(HeartRateZone.zone4));
      expect(zones, contains(HeartRateZone.zone5));
    });
  });
}