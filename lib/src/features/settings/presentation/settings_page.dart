import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/placeholder_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        children: [
          const PageHeader(
            icon: Icons.settings,
            title: AppStrings.settingsOverviewTitle,
            description: AppStrings.settingsOverviewDescription,
          ),
          const SizedBox(height: 24),
          
          // Polar BLE Demo Card
          Card(
            child: ListTile(
              leading: const Icon(Icons.bluetooth, color: Colors.blue),
              title: const Text('Polar BLE Demo'),
              subtitle: const Text('Test Polar H10 BLE connectivity and data streaming'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => context.push('/settings/polar-demo'),
            ),
          ),
          
          const SizedBox(height: 16),
          const PlaceholderCard(
            icon: Icons.science_outlined,
            title: AppStrings.developerOptionsTitle,
            description: AppStrings.developerOptionsDescription,
          ),
        ],
      ),
    );
  }
}
