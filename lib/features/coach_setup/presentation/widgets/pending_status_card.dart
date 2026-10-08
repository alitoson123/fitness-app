import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/coach_application_model.dart';

class PendingStatusCard extends StatelessWidget {
  final CoachApplicationModel application;

  const PendingStatusCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warning.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.hourglass_top_rounded,
              size: 38.r,
              color: AppColors.warning,
            ),
          ),
          SizedBox(height: AppSpacing.s4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              borderRadius: AppRadius.fullAll,
            ),
            child: Text(
              S.of(context).verificationPendingTitle,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.warning,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.s3),
          Text(
            S.of(context).applicationSubmitted,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.s2),
          Text(
            S.of(context).underReviewNotice,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: textSecondary,
              height: 1.45,
            ),
          ),
          SizedBox(height: AppSpacing.s4),
          Divider(color: isDark ? AppColors.darkBorder : AppColors.border),
          SizedBox(height: AppSpacing.s3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule_rounded, size: 16.r, color: textSecondary),
              SizedBox(width: 6.w),
              Text(
                S.of(context).expectedReviewTime,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
