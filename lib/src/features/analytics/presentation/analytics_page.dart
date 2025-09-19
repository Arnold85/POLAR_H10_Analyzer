import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/placeholder_card.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnalyticsView();
  }
}

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        children: const [
          PageHeader(
            icon: Icons.auto_graph,
            title: AppStrings.analysisOverviewTitle,
            description: AppStrings.analysisOverviewDescription,
          ),
          SizedBox(height: 24),
          PlaceholderCard(
            icon: Icons.analytics_outlined,
            title: AppStrings.analyticsPreparationTitle,
            description: AppStrings.analyticsPreparationDescription,
          ),
        ],
      ),
    );
  }
}
