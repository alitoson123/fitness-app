import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum AppSnackbarType { success, error, warning, info }

abstract class AppSnackbar {
  static Color _getBgColor(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return AppColors.success;
      case AppSnackbarType.error:
        return AppColors.error;
      case AppSnackbarType.warning:
        return AppColors.warning;
      case AppSnackbarType.info:
        return AppColors.primary;
    }
  }

  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarType type = AppSnackbarType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color bg = _getBgColor(type);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: bg,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }
}
