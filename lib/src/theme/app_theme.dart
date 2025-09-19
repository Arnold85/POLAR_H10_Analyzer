import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0xFF0066FF),
        ),
        cardTheme: const CardTheme(margin: EdgeInsets.zero),
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF0066FF),
        ),
        cardTheme: const CardTheme(margin: EdgeInsets.zero),
      );

}
