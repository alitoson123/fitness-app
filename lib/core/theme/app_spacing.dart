import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// CoachHub Spacing Scale & Margin/Padding Tokens (Responsive)
abstract class AppSpacing {
  static double get s1 => 4.w; // Micro gap — icon-to-text
  static double get s2 => 8.w; // Small gap — chip padding
  static double get s3 => 12.w; // Form element spacing
  static double get s4 => 16.w; // Standard — card padding, list item
  static double get s5 => 20.w; // Section internal spacing
  static double get s6 => 24.w; // Screen horizontal padding
  static double get s8 => 32.w; // Major gap between sections
  static double get s10 => 40.w; // Header spacing
  static double get s12 => 48.w; // Screen top padding
  static double get s16 => 64.w; // Large vertical rhythm

  // Semantic aliases
  static double get screenHorizontal => s6;
  static double get cardPadding => s4;
  static double get sectionGap => s8;
  static double get formFieldGap => s4;
  static double get formSectionGap => s6;
  static double get listItemGap => s3;
  static double get inlineGap => s2;
  static double get iconTextGap => s2;

  // Inset helpers
  static EdgeInsets get screenPadding => EdgeInsets.symmetric(horizontal: 24.w);
  static EdgeInsets get cardEdge => EdgeInsets.all(16.w);
  static EdgeInsets get sectionEdge => EdgeInsets.symmetric(vertical: 32.h);
}
