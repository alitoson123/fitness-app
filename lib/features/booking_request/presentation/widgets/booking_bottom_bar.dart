import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class BookingBottomBar extends StatelessWidget {
  final double price;
  final bool isMonthly;
  final bool isSubmitEnabled;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const BookingBottomBar({
    super.key,
    required this.price,
    this.isMonthly = false,
    required this.isSubmitEnabled,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final bg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMonthly ? s.totalMonthlyPrice : s.totalSessionPrice,
                  style: TextStyle(fontSize: 11.sp, color: textSecondary),
                ),
                Text(
                  '\$${price.toStringAsFixed(0)} USD',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton(
                onPressed: (isSubmitEnabled && !isSubmitting) ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  disabledBackgroundColor: primary.withValues(alpha: 0.4),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                ),
                child: isSubmitting
                    ? SizedBox(
                        height: 20.r,
                        width: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        s.confirmAndSendRequest,
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
