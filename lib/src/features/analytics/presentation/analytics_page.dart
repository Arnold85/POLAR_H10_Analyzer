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
          
          // HRV Metrics Section
          PlaceholderCard(
            icon: Icons.favorite_outlined,
            title: 'HRV-Metriken',
            description: 'RMSSD, SDNN, pNN50 und weitere Herzratenvariabilitäts-Kennzahlen.',
          ),
          SizedBox(height: 16),
          
          // Signal Processing Section
          PlaceholderCard(
            icon: Icons.graphic_eq_outlined,
            title: 'Signalverarbeitung',
            description: 'Filterung, Artefakterkennung, R-Peak-Detektion und Feature-Extraktion.',
          ),
          SizedBox(height: 16),
          
          // Stress Analysis Section
          PlaceholderCard(
            icon: Icons.psychology_outlined,
            title: 'Stress-Analyse',
            description: 'Sympathikus/Parasympathikus-Verhältnis und autonome Balance.',
          ),
          SizedBox(height: 16),
          
          // AI Analysis Section
          PlaceholderCard(
            icon: Icons.smart_toy_outlined,
            title: 'KI-Analyse',
            description: 'Lokale TensorFlow Lite Modelle und optionale Cloud-LLM Integration.',
          ),
          SizedBox(height: 16),
          
          // Validation Section
          PlaceholderCard(
            icon: Icons.verified_outlined,
            title: 'Validierung',
            description: 'Vergleich mit öffentlichen Datensätzen und Qualitätssicherung.',
          ),
        ],
      ),
    );
  }
}
