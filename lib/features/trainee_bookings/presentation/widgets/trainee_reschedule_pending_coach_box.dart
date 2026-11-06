import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class TraineeReschedulePendingCoachBox extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;

  const TraineeReschedulePendingCoachBox({
    super.key,
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
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
              Icon(Icons.schedule_rounded, size: 16.r, color: amberColor),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  s.reschedulePendingCoachBadge,
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
              color: textSecondary,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          if (booking.rescheduleReason?.isNotEmpty == true) ...[
            SizedBox(height: 6.h),
            Text(
              '${s.traineeReasonLabel}: "${booking.rescheduleReason}"',
              style: TextStyle(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                color: textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
