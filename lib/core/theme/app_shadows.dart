import 'package:flutter/material.dart';

/// CoachHub Elevation and BoxShadow Tokens
abstract class AppShadows {
  /// Level 0 — Flat
  static const List<BoxShadow> none = [];

  /// Level 1 — Cards, input fields (subtle lift)
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0D0F172A),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  /// Level 2 — Dropdowns, tooltips, sticky elements
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x140F172A),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x0D0F172A),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Level 3 — Modals, bottom sheets
  static const List<BoxShadow> level3 = [
    BoxShadow(
      color: Color(0x1F0F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0F0F172A),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  /// Primary button glow (Blue)
  static const List<BoxShadow> primary = [
    BoxShadow(
      color: Color(0x4D2563EB),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Flame Red glow (Dark Mode)
  static const List<BoxShadow> flame = [
    BoxShadow(
      color: Color(0x4DFF3D00),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Secondary button glow
  static const List<BoxShadow> secondary = [
    BoxShadow(
      color: Color(0x400D9488),
      blurRadius: 14,
      offset: Offset(0, 4),
    ),
  ];
}
