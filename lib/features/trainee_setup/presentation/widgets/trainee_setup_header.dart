import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class TraineeSetupHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const TraineeSetupHeader({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            S.of(context).stepOf(currentStep + 1, totalSteps),
            style: TextStyle(
              color: primary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          S.of(context).completeYourProfile,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          S.of(context).traineeSetupSubtitle,
          style: TextStyle(
            fontSize: 13.sp,
            color: textSecondary,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
