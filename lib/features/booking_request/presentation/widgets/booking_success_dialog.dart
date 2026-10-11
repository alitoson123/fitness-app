import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class BookingSuccessDialog extends StatelessWidget {
  final String coachName;
  final VoidCallback onDismiss;

  const BookingSuccessDialog({
    super.key,
    required this.coachName,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required String coachName,
    required VoidCallback onDismiss,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BookingSuccessDialog(
        coachName: coachName,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.darkSurface : Colors.white;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.xlAll),
      backgroundColor: bg,
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded, size: 40.r, color: Colors.green),
            ),
            SizedBox(height: 16.h),
            Text(
              S.of(context).bookingSuccessTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              S.of(context).bookingSuccessDescription(coachName),
              style: TextStyle(
                fontSize: 13.sp,
                color: textSecondary,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                ),
                child: Text(
                  S.of(context).backToExplore,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
