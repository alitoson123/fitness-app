import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';

class OnboardingHeader extends StatelessWidget {
  final VoidCallback onSkip;
  final bool showSkip;

  const OnboardingHeader({
    super.key,
    required this.onSkip,
    this.showSkip = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.darkSurfaceVariant,
              borderRadius: AppRadius.fullAll,
              border: Border.all(color: AppColors.darkBorder, width: 1.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fitness_center_rounded,
                  size: 16.r,
                  color: AppColors.flameRed,
                ),
                SizedBox(width: 6.w),
                Text(
                  S.of(context).appName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          AnimatedOpacity(
            opacity: showSkip ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: TextButton(
              onPressed: showSkip ? onSkip : null,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkTextSecondary,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                S.of(context).skip,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
