import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class BookingCardCompactProgress extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;

  const BookingCardCompactProgress({
    super.key,
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final nextSession = booking.nextUpcomingSession;

    return Padding(
      padding: EdgeInsets.only(top: 8.h),
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
                  fontWeight: FontWeight.w600,
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
          SizedBox(height: 5.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(3.r),
            child: LinearProgressIndicator(
              value: booking.progressRatio,
              minHeight: 4.h,
              backgroundColor: isDark ? AppColors.darkBorder : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          if (nextSession != null) ...[
            SizedBox(height: 5.h),
            Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  size: 11.r,
                  color: textSecondary,
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    s.nextSessionLabel(nextSession.date, nextSession.startTime),
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

