import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../generated/l10n.dart';

class CoachDashboardHeader extends StatelessWidget {
  final String? email;

  const CoachDashboardHeader({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.secondary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: AppRadius.fullAll,
          ),
          child: Text(
            S.of(context).testModeBadge,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: accent,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Container(
          width: 80.r,
          height: 80.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF0FDF4),
          ),
          child: Icon(
            Icons.sports_rounded,
            color: accent,
            size: 40.r,
          ),
        ),
        SizedBox(height: AppSpacing.s4),
        Text(
          S.of(context).fakeCoachDashboardTitle,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSpacing.s2),
        Text(
          S.of(context).fakeCoachDashboardSubtitle,
          style: TextStyle(
            fontSize: 13.sp,
            height: 1.4,
            color: textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (email != null && email!.isNotEmpty) ...[
          SizedBox(height: AppSpacing.s3),
          Text(
            S.of(context).currentUserInfo(email!),
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
