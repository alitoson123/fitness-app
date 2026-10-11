import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../helpers/coach_booking_date_helper.dart';

class WeekStrip extends StatelessWidget {
  final List<BookingModel> bookings;

  const WeekStrip({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weekDays = CoachBookingDateHelper.getWeekDays(bookings);
    final locale = Localizations.localeOf(context).languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.thisWeekSchedule,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: weekDays.map((dayItem) {
            final dayName = DateFormat('E', locale).format(dayItem.date);
            final dayNum = dayItem.date.day.toString();
            final isToday = dayItem.isToday;
            final count = dayItem.count;

            final cardBg = isToday
                ? AppColors.flameRed.withValues(alpha: 0.12)
                : (isDark ? AppColors.darkSurface : Colors.white);
            final border = isToday
                ? AppColors.flameRed
                : (isDark ? AppColors.darkBorder : AppColors.border);

            return Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: AppRadius.smAll,
                  border: Border.all(
                    color: border,
                    width: isToday ? 1.5 : 1.0,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                        color: isToday
                            ? AppColors.flameRed
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                      ),
                      maxLines: 1,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dayNum,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: isToday
                            ? AppColors.flameRed
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    if (count > 0)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.flameRed,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )
                    else
                      SizedBox(height: 12.h),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
