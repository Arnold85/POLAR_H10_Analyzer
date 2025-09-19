import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/placeholder_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DashboardView();
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        children: const [
          PageHeader(
            icon: Icons.monitor_heart,
            title: AppStrings.liveMonitoringTitle,
            description: AppStrings.liveMonitoringDescription,
          ),
          SizedBox(height: 24),
          PlaceholderCard(
            icon: Icons.bluetooth_connected,
            title: AppStrings.connectionStatusTitle,
            description: AppStrings.connectionStatusDescription,
          ),
          SizedBox(height: 16),
          PlaceholderCard(
            icon: Icons.show_chart,
            title: AppStrings.signalPreviewTitle,
            description: AppStrings.signalPreviewDescription,
          ),
        ],
      ),
    );
  }
}
