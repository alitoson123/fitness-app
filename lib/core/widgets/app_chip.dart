import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? icon;

  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.flameRed : AppColors.primary;
    final unselectedBg = isDark ? AppColors.darkSurface : Colors.white;
    final unselectedBorder = isDark ? AppColors.darkBorder : AppColors.border;
    final unselectedTextColor = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final activeShadow = isDark ? AppShadows.flame : AppShadows.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? primaryColor : unselectedBg,
          borderRadius: AppRadius.fullAll,
          border: Border.all(
            color: selected ? primaryColor : unselectedBorder,
            width: 1.5.w,
          ),
          boxShadow: selected ? activeShadow : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: selected ? Colors.white : unselectedTextColor,
                  size: 16.r,
                ),
                child: icon!,
              ),
              SizedBox(width: AppSpacing.s1),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : unselectedTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
