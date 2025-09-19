import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => _buildTheme(Brightness.light);

  static ThemeData get dark => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) => ThemeData(
        brightness: brightness,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: brightness,
          seedColor: const Color(0xFF0066FF),
        ),
        cardTheme: const CardTheme(margin: EdgeInsets.zero),
      );
}
