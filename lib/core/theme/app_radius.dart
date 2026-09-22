import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// CoachHub Border Radius Tokens & Insets (Responsive)
abstract class AppRadius {
  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get md => 12.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get xxl => 24.r;
  static double get full => 999.r;

  // BorderRadius shortcuts
  static BorderRadius get xsAll => BorderRadius.circular(xs);
  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
  static BorderRadius get xxlAll => BorderRadius.circular(xxl);
  static BorderRadius get fullAll => BorderRadius.circular(full);

  // Bottom Sheet Radius
  static BorderRadius get bottomSheetTop => BorderRadius.only(
        topLeft: Radius.circular(xxl),
        topRight: Radius.circular(xxl),
      );
}
