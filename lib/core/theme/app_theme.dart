import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

/// CoachHub Theme Provider (Light & Sporty Dark Mode)
abstract class AppTheme {
  static ThemeData get lightTheme => buildLightTheme();
  static ThemeData get darkTheme => buildDarkTheme();
}
