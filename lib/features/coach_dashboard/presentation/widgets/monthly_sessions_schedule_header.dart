import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_sports.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class MonthlySessionsScheduleHeader extends StatelessWidget {
  final BookingModel booking;
  final bool isCoach;

  const MonthlySessionsScheduleHeader({
    super.key,
    required this.booking,
    required this.isCoach,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.sessionsSchedule,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${AppSports.getLocalizedSportName(context, booking.sport)} • ${isCoach ? booking.traineeName : booking.coachName}',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.primary),
                ),
              ],
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: booking.progressRatio,
                  minHeight: 6.h,
                  backgroundColor: isDark ? AppColors.darkBorder : Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '${booking.completedSessionsCount}/${booking.sessionsCount}',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

