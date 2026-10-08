import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class ExperienceOptionCard extends StatelessWidget {
  final int years;
  final bool isSelected;
  final bool isDark;
  final Color primaryColor;
  final VoidCallback onTap;

  const ExperienceOptionCard({
    super.key,
    required this.years,
    required this.isSelected,
    required this.isDark,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected
                ? primaryColor
                : isDark
                    ? AppColors.darkSurface
                    : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected
                  ? primaryColor
                  : isDark
                      ? AppColors.darkBorder
                      : AppColors.border,
            ),
          ),
          child: Center(
            child: Text(
              '$years+',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.onPrimary
                    : isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
