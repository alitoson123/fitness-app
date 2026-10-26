import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraineeRescheduleAlertBox extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;
  final bool isActionInProgress;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const TraineeRescheduleAlertBox({
    super.key,
    required this.booking,
    required this.isDark,
    required this.isActionInProgress,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    const amberColor = Color(0xFFF59E0B);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: amberColor.withValues(alpha: 0.08),
        borderRadius: AppRadius.smAll,
        border: Border.all(
          color: amberColor.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_calendar_rounded, size: 16.r, color: amberColor),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  s.coachProposedNewTime,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: amberColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '${s.proposedTimeLabel}: ${booking.proposedDate} (${booking.proposedStartTime} - ${booking.proposedEndTime})',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '${s.originalTimeLabel}: ${booking.date} (${booking.startTime} - ${booking.endTime})',
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          if (booking.rescheduleReason?.isNotEmpty == true) ...[
            SizedBox(height: 6.h),
            Text(
              '${s.coachReasonLabel}: "${booking.rescheduleReason}"',
              style: TextStyle(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          if (isActionInProgress)
            const Center(
              child: SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    child: Text(s.declineReschedule, style: TextStyle(fontSize: 11.sp)),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                    ),
                    child: Text(s.acceptNewTime, style: TextStyle(fontSize: 11.sp)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
