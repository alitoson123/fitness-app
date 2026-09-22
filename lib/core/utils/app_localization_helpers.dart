import 'package:flutter/material.dart';

/// RTL and Directionality localization utilities
abstract class AppLocalizationHelpers {
  static Widget rtl(Widget child) =>
      Directionality(textDirection: TextDirection.rtl, child: child);

  static Widget ltr(Widget child) =>
      Directionality(textDirection: TextDirection.ltr, child: child);

  static bool isRtl(BuildContext context) =>
      Directionality.of(context) == TextDirection.rtl;

  static TextStyle arabicStyle(TextStyle base) =>
      base.copyWith(fontFamily: 'NotoSansArabic');

  static EdgeInsets mirroredPadding(
    BuildContext context, {
    required double start,
    required double end,
    double top = 0,
    double bottom = 0,
  }) {
    final bool rtl = isRtl(context);
    return EdgeInsets.fromLTRB(
      rtl ? end : start,
      top,
      rtl ? start : end,
      bottom,
    );
  }
}
