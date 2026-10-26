import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../helpers/coach_booking_date_helper.dart';

class BookingCardRescheduleInfo extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;

  const BookingCardRescheduleInfo({
    super.key,
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final proposedDate = booking.proposedDate;
    final dateFormatted = proposedDate != null
        ? CoachBookingDateHelper.formatHumanDate(context, proposedDate)
        : '';
    const amberColor = Color(0xFFF59E0B);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: amberColor.withValues(alpha: 0.08),
        borderRadius: AppRadius.smAll,
        border: Border.all(
          color: amberColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.schedule_send_rounded, size: 14.r, color: amberColor),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  s.reschedulePendingBadge,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: amberColor,
                  ),
                ),
              ),
            ],
          ),
          if (dateFormatted.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              '${s.proposedTimeLabel}: $dateFormatted (${booking.proposedStartTime} - ${booking.proposedEndTime})',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ],
          if (booking.rescheduleReason?.isNotEmpty == true) ...[
            SizedBox(height: 4.h),
            Text(
              '${s.coachReasonLabel}: "${booking.rescheduleReason}"',
              style: TextStyle(
                fontSize: 11.sp,
                fontStyle: FontStyle.italic,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
