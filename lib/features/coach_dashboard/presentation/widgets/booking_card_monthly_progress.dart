import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class BookingCardMonthlyProgress extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;
  final VoidCallback onViewSchedule;

  const BookingCardMonthlyProgress({
    super.key,
    required this.booking,
    required this.isDark,
    required this.onViewSchedule,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final nextSession = booking.nextUpcomingSession;

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkBackground.withValues(alpha: 0.5)
            : const Color(0xFFF8FAFC),
        borderRadius: AppRadius.smAll,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                s.monthlyProgressCompleted(
                  booking.completedSessionsCount,
                  booking.sessionsCount,
                ),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              Text(
                '${(booking.progressRatio * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: booking.progressRatio,
              minHeight: 6.h,
              backgroundColor: isDark ? AppColors.darkBorder : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.event_available_rounded, size: 13.r, color: textSecondary),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  nextSession != null
                      ? s.nextSessionLabel(nextSession.date, nextSession.startTime)
                      : s.noUpcomingSessions,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewSchedule,
              icon: Icon(Icons.calendar_month_rounded, size: 14.r),
              label: Text(s.viewSessionsSchedule, style: TextStyle(fontSize: 11.sp)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                padding: EdgeInsets.symmetric(vertical: 6.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

