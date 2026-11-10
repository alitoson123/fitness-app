import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class EmptyNotificationsView extends StatelessWidget {
  final bool isFiltered;

  const EmptyNotificationsView({super.key, this.isFiltered = false});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.neutral100,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.neutral200,
                  width: 1.5.w,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_off_outlined,
                  size: 40.sp,
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.neutral400,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              s.emptyNotificationsTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              isFiltered
                  ? s.emptyFilterNotificationsDesc
                  : s.emptyNotificationsDesc,
              style: TextStyle(
                fontSize: 14.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.neutral500,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
