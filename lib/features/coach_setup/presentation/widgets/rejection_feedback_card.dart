import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/coach_application_model.dart';

class RejectionFeedbackCard extends StatelessWidget {
  final CoachApplicationModel application;
  final String rejectionReason;
  final VoidCallback onEditAndResubmit;

  const RejectionFeedbackCard({
    super.key,
    required this.application,
    required this.rejectionReason,
    required this.onEditAndResubmit,
  });

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
          color: AppColors.error.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 72.r,
              height: 72.r,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 38.r,
                color: AppColors.error,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.s4),
          Center(
            child: Text(
              S.of(context).applicationNeedsAttention,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.s3),
          Text(
            S.of(context).rejectionReasonLabel,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: AppSpacing.s2),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: AppRadius.mdAll,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              rejectionReason.isNotEmpty
                  ? rejectionReason
                  : S.of(context).defaultRejectionReason,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: textSecondary,
                height: 1.45,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.s6),
          AppButton(
            label: S.of(context).editAndResubmit,
            fullWidth: true,
            icon: Icon(Icons.edit_note_rounded, size: 20.r),
            onPressed: onEditAndResubmit,
          ),
        ],
      ),
    );
  }
}
