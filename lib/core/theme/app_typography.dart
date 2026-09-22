import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// CoachHub Typography Tokens & TextStyles (Responsive)
abstract class AppTypography {
  static const String fontDisplay = 'PlusJakartaSans';
  static const String fontBody = 'Inter';
  static const String fontArabic = 'NotoSansArabic';

  // Display
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        height: 1.10,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        fontSize: 28.sp,
        fontWeight: FontWeight.w800,
        height: 1.15,
        letterSpacing: -0.4,
        color: AppColors.textPrimary,
      );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        height: 1.20,
        letterSpacing: -0.3,
        color: AppColors.textPrimary,
      );

  // Headlines
  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        height: 1.30,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        height: 1.30,
        letterSpacing: -0.2,
        color: AppColors.textPrimary,
      );

  static TextStyle get headlineSmall => GoogleFonts.plusJakartaSans(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 1.35,
        letterSpacing: -0.1,
        color: AppColors.textPrimary,
      );

  // Titles
  static TextStyle get titleLarge => GoogleFonts.plusJakartaSans(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        height: 1.40,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        height: 1.40,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.plusJakartaSans(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        height: 1.40,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
      );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.60,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.60,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        height: 1.60,
        color: AppColors.textPrimary,
      );

  // Labels
  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        height: 1.40,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.plusJakartaSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        height: 1.40,
        letterSpacing: 0.8,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        height: 1.40,
        letterSpacing: 1.0,
        color: AppColors.textPrimary,
      );
}
