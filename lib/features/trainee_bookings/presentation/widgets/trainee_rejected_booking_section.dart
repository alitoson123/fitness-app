import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class TraineeRejectedBookingSection extends StatelessWidget {
  final String? rejectionReason;
  final VoidCallback onRebook;

  const TraineeRejectedBookingSection({
    super.key,
    required this.rejectionReason,
    required this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: AppRadius.smAll,
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14.r,
                color: AppColors.error,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  rejectionReason?.isNotEmpty == true
                      ? s.sessionDeclineReason(rejectionReason!)
                      : s.statusDeclined,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRebook,
            icon: Icon(Icons.refresh_rounded, size: 14.r),
            label: Text(
              s.bookNewSession,
              style: TextStyle(fontSize: 12.sp),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
              padding: EdgeInsets.symmetric(vertical: 8.h),
            ),
          ),
        ),
      ],
    );
  }
}

