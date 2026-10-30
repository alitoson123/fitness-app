import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/booking_request_cubit/booking_slot_calculator.dart';

class BookingDateStrip extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final CoachProfileModel coach;
  final ValueChanged<DateTime> onSelectDate;
  final String? title;

  const BookingDateStrip({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.coach,
    required this.onSelectDate,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final unselectedBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? S.of(context).selectTrainingDate,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 86.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            separatorBuilder: (_, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = selectedDate != null &&
                  selectedDate!.year == date.year &&
                  selectedDate!.month == date.month &&
                  selectedDate!.day == date.day;
              final isWorking =
                  BookingSlotCalculator.isCoachWorkingOnDay(coach, date);

              final dayName = DateFormat(
                'E',
                Localizations.localeOf(context).languageCode,
              ).format(date);
              final dayNum = date.day.toString();

              return Opacity(
                opacity: isWorking ? 1.0 : 0.45,
                child: InkWell(
                  borderRadius: AppRadius.mdAll,
                  onTap: isWorking ? () => onSelectDate(date) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 64.w,
                    padding:
                        EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : unselectedBg,
                      borderRadius: AppRadius.mdAll,
                      border: Border.all(
                        color: isSelected ? primary : border,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dayName,
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : textSecondary,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              dayNum,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : textPrimary,
                              ),
                            ),
                            if (!isWorking) ...[
                              SizedBox(height: 2.h),
                              Text(
                                S.of(context).dayUnavailable,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
