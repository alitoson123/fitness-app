import 'package:flutter/material.dart';

/// CoachHub Color Palette & Tokens (Light & Sporty Dark Mode)
abstract class AppColors {
  // ── Light Primary scale (Blue) ──────────────────────────────
  static const Color primary50 = Color(0xFFEFF6FF);
  static const Color primary100 = Color(0xFFDBEAFE);
  static const Color primary200 = Color(0xFFBFDBFE);
  static const Color primary300 = Color(0xFF93C5FD);
  static const Color primary400 = Color(0xFF60A5FA);
  static const Color primary500 = Color(0xFF3B82F6);
  static const Color primary600 = Color(0xFF2563EB);
  static const Color primary700 = Color(0xFF1D4ED8);
  static const Color primary = primary600;
  static const Color primaryDark = primary700;
  static const Color primaryLight = primary500;
  static const Color primaryContainer = primary50;
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Sporty Flame Red Accent (Dark Mode Main Brand) ──────────
  static const Color flameRed = Color(0xFFFF3D00);
  static const Color flameRedDark = Color(0xFFE03400);
  static const Color flameRedLight = Color(0xFFFF6434);
  static const Color flameRedContainer = Color(0x33FF3D00);

  // ── Secondary scale (Teal) ──────────────────────────────────
  static const Color secondary = Color(0xFF0D9488);
  static const Color secondaryDark = Color(0xFF0F766E);
  static const Color secondary50 = Color(0xFFF0FDFA);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // ── Light Neutral Scale ─────────────────────────────────────
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral900 = Color(0xFF0F172A);

  // ── Dark Neutral Scale (Sporty Pitch Dark) ──────────────────
  static const Color darkBackground = Color(0xFF0F0F12);
  static const Color darkSurface = Color(0xFF1C1C22);
  static const Color darkSurfaceVariant = Color(0xFF24242C);
  static const Color darkBorder = Color(0xFF2C2C35);
  static const Color darkBorderStrong = Color(0xFF3F3F4A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextTertiary = Color(0xFF71717A);
  static const Color darkDivider = Color(0xFF202026);

  // ── Semantic surfaces & text (Light defaults) ───────────────
  static const Color background = neutral0;
  static const Color surface = neutral50;
  static const Color surfaceVariant = neutral100;
  static const Color textPrimary = neutral900;
  static const Color textSecondary = neutral500;
  static const Color textTertiary = neutral400;
  static const Color border = neutral200;
  static const Color divider = neutral100;

  // ── Semantic alerts ─────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF2563EB);

  // ── Gradients ───────────────────────────────────────────────
  static const List<Color> splashGradient = [
    Color(0xFF1C1C22),
    Color(0xFF121214),
    Color(0xFF0F0F12),
  ];
  static const List<Color> darkCardGradient = [
    Color(0xFF22222A),
    Color(0xFF1C1C22),
  ];
  static const List<Color> flameGradient = [
    Color(0xFFFF3D00),
    Color(0xFFFF6434),
  ];
  static const List<Color> avatarGradient = [flameRed, Color(0xFFFF6434)];
}
