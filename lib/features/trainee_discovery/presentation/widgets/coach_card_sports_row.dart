import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class CoachCardSportsRow extends StatelessWidget {
  final List<String> sports;
  final Color primaryColor;
  final bool isDark;

  const CoachCardSportsRow({
    super.key,
    required this.sports,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();
    final visibleSports = sports.take(2).toList();
    final remaining = sports.length - visibleSports.length;

    return Wrap(
      spacing: 6.w,
      children: [
        ...visibleSports.map(
          (sport) => Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.smAll,
            ),
            child: Text(
              sport,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
        if (remaining > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: AppRadius.smAll,
            ),
            child: Text(
              '+$remaining',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}
