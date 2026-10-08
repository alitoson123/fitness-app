import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../models/day_availability.dart';
import 'availability_helper.dart';

class UnavailableDayCard extends StatelessWidget {
  final DayAvailability availability;
  final bool isDark;
  final VoidCallback onTap;

  const UnavailableDayCard({
    super.key,
    required this.availability,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = AvailabilityHelper.getDayFullName(
      context,
      availability.day,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkSurface.withValues(alpha: 0.4)
              : AppColors.surfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder.withValues(alpha: 0.5)
                : AppColors.border.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dayName,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            Text(
              S.of(context).unavailable,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isDark
                    ? AppColors.darkTextSecondary.withValues(alpha: 0.6)
                    : AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
