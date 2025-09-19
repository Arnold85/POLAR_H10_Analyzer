import 'package:flutter_test/flutter_test.dart';
import 'package:polar_h10_analyzer/src/domain/models/stress_indicator.dart';

void main() {
  group('StressIndicator', () {
    test('should create StressIndicator with required fields', () {
      final now = DateTime.now();
      final indicator = StressIndicator(
        stressLevel: 0.6,
        sympatheticActivity: 0.7,
        parasympatheticActivity: 0.4,
        balanceRatio: 1.75, // 0.7 / 0.4
        calculatedAt: now,
      );

      expect(indicator.stressLevel, equals(0.6));
      expect(indicator.sympatheticActivity, equals(0.7));
      expect(indicator.parasympatheticActivity, equals(0.4));
      expect(indicator.balanceRatio, equals(1.75));
      expect(indicator.calculatedAt, equals(now));
      expect(indicator.confidence, isNull);
      expect(indicator.trends, isNull);
    });

    test('should categorize stress levels correctly', () {
      final now = DateTime.now();

      final veryLowStress = StressIndicator(
        stressLevel: 0.1,
        sympatheticActivity: 0.2,
        parasympatheticActivity: 0.8,
        balanceRatio: 0.25,
        calculatedAt: now,
      );
      expect(veryLowStress.stressCategory, equals(StressLevel.veryLow));

      final lowStress = StressIndicator(
        stressLevel: 0.3,
        sympatheticActivity: 0.4,
        parasympatheticActivity: 0.6,
        balanceRatio: 0.67,
        calculatedAt: now,
      );
      expect(lowStress.stressCategory, equals(StressLevel.low));

      final moderateStress = StressIndicator(
        stressLevel: 0.5,
        sympatheticActivity: 0.6,
        parasympatheticActivity: 0.5,
        balanceRatio: 1.2,
        calculatedAt: now,
      );
      expect(moderateStress.stressCategory, equals(StressLevel.moderate));

      final highStress = StressIndicator(
        stressLevel: 0.7,
        sympatheticActivity: 0.8,
        parasympatheticActivity: 0.3,
        balanceRatio: 2.67,
        calculatedAt: now,
      );
      expect(highStress.stressCategory, equals(StressLevel.high));

      final veryHighStress = StressIndicator(
        stressLevel: 0.9,
        sympatheticActivity: 0.9,
        parasympatheticActivity: 0.2,
        balanceRatio: 4.5,
        calculatedAt: now,
      );
      expect(veryHighStress.stressCategory, equals(StressLevel.veryHigh));
    });

    test('should provide correct balance descriptions', () {
      final now = DateTime.now();

      final highSympathetic = StressIndicator(
        stressLevel: 0.8,
        sympatheticActivity: 0.9,
        parasympatheticActivity: 0.2,
        balanceRatio: 2.0, // High sympathetic dominance
        calculatedAt: now,
      );
      expect(highSympathetic.balanceDescription, contains('High sympathetic dominance'));

      final balanced = StressIndicator(
        stressLevel: 0.4,
        sympatheticActivity: 0.5,
        parasympatheticActivity: 0.5,
        balanceRatio: 1.0, // Balanced
        calculatedAt: now,
      );
      expect(balanced.balanceDescription, contains('Balanced autonomic state'));

      final highParasympathetic = StressIndicator(
        stressLevel: 0.2,
        sympatheticActivity: 0.2,
        parasympatheticActivity: 0.8,
        balanceRatio: 0.3, // High parasympathetic dominance
        calculatedAt: now,
      );
      expect(highParasympathetic.balanceDescription, contains('High parasympathetic dominance'));
    });

    test('should create complete StressIndicator with trends', () {
      final now = DateTime.now();
      final trend = StressTrend(
        direction: TrendDirection.increasing,
        magnitude: 0.3,
        timeWindow: const Duration(minutes: 30),
      );

      final indicator = StressIndicator(
        stressLevel: 0.6,
        sympatheticActivity: 0.7,
        parasympatheticActivity: 0.4,
        balanceRatio: 1.75,
        calculatedAt: now,
        confidence: 0.85,
        trends: trend,
      );

      expect(indicator.confidence, equals(0.85));
      expect(indicator.trends, equals(trend));
      expect(indicator.trends!.direction, equals(TrendDirection.increasing));
      expect(indicator.trends!.magnitude, equals(0.3));
      expect(indicator.trends!.timeWindow, equals(const Duration(minutes: 30)));
    });

    test('should have proper equality comparison', () {
      final now = DateTime.now();
      final indicator1 = StressIndicator(
        stressLevel: 0.6,
        sympatheticActivity: 0.7,
        parasympatheticActivity: 0.4,
        balanceRatio: 1.75,
        calculatedAt: now,
      );

      final indicator2 = StressIndicator(
        stressLevel: 0.6,
        sympatheticActivity: 0.7,
        parasympatheticActivity: 0.4,
        balanceRatio: 1.75,
        calculatedAt: now,
      );

      final indicator3 = StressIndicator(
        stressLevel: 0.5,
        sympatheticActivity: 0.7,
        parasympatheticActivity: 0.4,
        balanceRatio: 1.75,
        calculatedAt: now,
      );

      expect(indicator1, equals(indicator2));
      expect(indicator1.hashCode, equals(indicator2.hashCode));
      expect(indicator1, isNot(equals(indicator3)));
    });
  });

  group('StressLevel', () {
    test('should have correct stress level names', () {
      expect(StressLevel.veryLow.name, equals('Very Low'));
      expect(StressLevel.low.name, equals('Low'));
      expect(StressLevel.moderate.name, equals('Moderate'));
      expect(StressLevel.high.name, equals('High'));
      expect(StressLevel.veryHigh.name, equals('Very High'));
    });

    test('should have appropriate descriptions', () {
      expect(StressLevel.veryLow.description, contains('Excellent recovery'));
      expect(StressLevel.low.description, contains('Good recovery'));
      expect(StressLevel.moderate.description, contains('Moderate stress'));
      expect(StressLevel.high.description, contains('Elevated stress'));
      expect(StressLevel.veryHigh.description, contains('Very high stress'));
    });
  });

  group('StressTrend', () {
    test('should create StressTrend correctly', () {
      final trend = StressTrend(
        direction: TrendDirection.decreasing,
        magnitude: 0.4,
        timeWindow: const Duration(hours: 1),
      );

      expect(trend.direction, equals(TrendDirection.decreasing));
      expect(trend.magnitude, equals(0.4));
      expect(trend.timeWindow, equals(const Duration(hours: 1)));
    });

    test('should have proper equality comparison', () {
      final trend1 = StressTrend(
        direction: TrendDirection.stable,
        magnitude: 0.1,
        timeWindow: const Duration(minutes: 15),
      );

      final trend2 = StressTrend(
        direction: TrendDirection.stable,
        magnitude: 0.1,
        timeWindow: const Duration(minutes: 15),
      );

      final trend3 = StressTrend(
        direction: TrendDirection.increasing,
        magnitude: 0.1,
        timeWindow: const Duration(minutes: 15),
      );

      expect(trend1, equals(trend2));
      expect(trend1.hashCode, equals(trend2.hashCode));
      expect(trend1, isNot(equals(trend3)));
    });
  });

  group('TrendDirection', () {
    test('should have all expected trend directions', () {
      final directions = TrendDirection.values;
      expect(directions.length, equals(3));
      expect(directions, contains(TrendDirection.increasing));
      expect(directions, contains(TrendDirection.decreasing));
      expect(directions, contains(TrendDirection.stable));
    });
  });
}