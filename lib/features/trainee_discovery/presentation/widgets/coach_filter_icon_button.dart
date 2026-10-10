import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class CoachFilterIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final int activeCount;
  final Color primaryColor;
  final bool isDark;

  const CoachFilterIconButton({
    super.key,
    required this.onTap,
    required this.activeCount,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurfaceVariant : AppColors.surface;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdAll,
          child: Container(
            width: 46.h,
            height: 46.h,
            decoration: BoxDecoration(
              color:
                  activeCount > 0 ? primaryColor.withValues(alpha: 0.12) : bg,
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: activeCount > 0 ? primaryColor : border,
                width: activeCount > 0 ? 1.5 : 1,
              ),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: activeCount > 0
                  ? primaryColor
                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              size: 20.r,
            ),
          ),
        ),
        if (activeCount > 0)
          Positioned(
            top: -4.h,
            right: -4.w,
            child: Container(
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                '$activeCount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
