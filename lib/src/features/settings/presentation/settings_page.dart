import 'package:flutter/material.dart';

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
        children: const [
          PageHeader(
            icon: Icons.settings,
            title: AppStrings.settingsOverviewTitle,
            description: AppStrings.settingsOverviewDescription,
          ),
          SizedBox(height: 24),
          PlaceholderCard(
            icon: Icons.science_outlined,
            title: AppStrings.developerOptionsTitle,
            description: AppStrings.developerOptionsDescription,
          ),
        ],
      ),
    );
  }
}
