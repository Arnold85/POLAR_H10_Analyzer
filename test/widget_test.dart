import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:polar_h10_analyzer/src/app.dart';
import 'package:polar_h10_analyzer/src/constants/app_strings.dart';

void main() {
  testWidgets('initial tab shows dashboard content and navigation works', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: PolarH10AnalyzerApp()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.liveMonitoringTitle), findsOneWidget);

    await tester.tap(find.text(AppStrings.sessionsTabLabel));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.sessionsOverviewTitle), findsOneWidget);
  });
}
