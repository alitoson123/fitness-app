import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class TraineeCancelledBookingSection extends StatelessWidget {
  final String? cancellationReason;
  final VoidCallback onRebook;

  const TraineeCancelledBookingSection({
    super.key,
    required this.cancellationReason,
    required this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        if (cancellationReason?.isNotEmpty == true)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text(
              cancellationReason!,
              style: TextStyle(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                color: AppColors.error,
              ),
            ),
          ),
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

