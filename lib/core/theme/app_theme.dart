import 'package:flutter/material.dart';
import 'dark_theme.dart';

/// CoachHub Theme Provider (Pure Sporty Dark Mode)
abstract class AppTheme {
  static ThemeData get lightTheme => buildDarkTheme();
  static ThemeData get darkTheme => buildDarkTheme();
  static ThemeData get theme => buildDarkTheme();
}
