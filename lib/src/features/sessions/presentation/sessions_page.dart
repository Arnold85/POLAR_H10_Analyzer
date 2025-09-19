import 'package:flutter/material.dart';

import '../../../constants/app_strings.dart';
import '../../../widgets/page_header.dart';
import '../../../widgets/placeholder_card.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SessionsView();
  }
}

class SessionsView extends StatelessWidget {
  const SessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        children: const [
          PageHeader(
            icon: Icons.history_toggle_off,
            title: AppStrings.sessionsOverviewTitle,
            description: AppStrings.sessionsOverviewDescription,
          ),
          SizedBox(height: 24),
          PlaceholderCard(
            icon: Icons.file_upload_outlined,
            title: AppStrings.exportToolsTitle,
            description: AppStrings.exportToolsDescription,
          ),
          SizedBox(height: 16),
          PlaceholderCard(
            icon: Icons.label_outline,
            title: AppStrings.sessionTagsTitle,
            description: AppStrings.sessionTagsDescription,
          ),
        ],
      ),
    );
  }
}
