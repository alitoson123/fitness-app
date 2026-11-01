import 'package:flutter/material.dart';

/// CoachHub Color Palette & Tokens (Sporty Pure Dark Mode)
abstract class AppColors {
  // ── Sporty Flame Red Accent (Main Brand) ───────────────────
  static const Color flameRed = Color(0xFFFF3D00);
  static const Color flameRedDark = Color(0xFFE03400);
  static const Color flameRedLight = Color(0xFFFF6434);
  static const Color flameRedContainer = Color(0x33FF3D00);

  // ── Primary scale (Pure Dark Flame Red) ──────────────────────
  static const Color primary50 = Color(0x1AFF3D00);
  static const Color primary100 = Color(0x26FF3D00);
  static const Color primary200 = Color(0x33FF3D00);
  static const Color primary300 = Color(0x4DFF3D00);
  static const Color primary400 = flameRedLight;
  static const Color primary500 = flameRed;
  static const Color primary600 = flameRed;
  static const Color primary700 = flameRedDark;
  static const Color primary = flameRed;
  static const Color primaryDark = flameRedDark;
  static const Color primaryLight = flameRedLight;
  static const Color primaryContainer = flameRedContainer;
  static const Color onPrimary = Color(0xFFFFFFFF);

  // ── Secondary scale (Teal) ──────────────────────────────────
  static const Color secondary = Color(0xFF0D9488);
  static const Color secondaryDark = Color(0xFF0F766E);
  static const Color secondary50 = Color(0x330D9488);
  static const Color onSecondary = Color(0xFFFFFFFF);

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

  // ── Light Neutral Scale (Legacy Fallback) ───────────────────
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral900 = Color(0xFF0F172A);

  // ── Semantic surfaces & text (Strict Dark Defaults) ─────────
  static const Color background = darkBackground;
  static const Color surface = darkSurface;
  static const Color surfaceVariant = darkSurfaceVariant;
  static const Color backgroundSecondary = darkSurfaceVariant;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color textTertiary = darkTextTertiary;
  static const Color border = darkBorder;
  static const Color cardBorder = darkBorder;
  static const Color divider = darkDivider;
  static const Color cardBackground = darkSurface;
  static const Color darkCardBackground = darkSurface;

  // ── Semantic alerts ─────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0x2610B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0x26F59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0x26EF4444);
  static const Color info = flameRed;

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
