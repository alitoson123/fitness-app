import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../../../booking_request/presentation/view_model/booking_request_cubit/booking_slot_calculator.dart';

class RescheduleDatePicker extends StatelessWidget {
  final List<DateTime> dates;
  final DateTime? selectedDate;
  final CoachProfileModel coach;
  final ValueChanged<DateTime> onSelectDate;

  const RescheduleDatePicker({
    super.key,
    required this.dates,
    required this.selectedDate,
    required this.coach,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = AppColors.primary;

    return SizedBox(
      height: 76.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = selectedDate != null &&
              selectedDate!.year == date.year &&
              selectedDate!.month == date.month &&
              selectedDate!.day == date.day;
          final isWorking =
              BookingSlotCalculator.isCoachWorkingOnDay(coach, date);

          final dayName = DateFormat('E', Localizations.localeOf(context).languageCode).format(date);
          final dayNum = date.day.toString();

          return InkWell(
            onTap: isWorking ? () => onSelectDate(date) : null,
            borderRadius: AppRadius.smAll,
            child: Opacity(
              opacity: isWorking ? 1.0 : 0.35,
              child: Container(
                width: 58.w,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary
                      : (isDark ? AppColors.darkSurfaceVariant : Colors.white),
                  borderRadius: AppRadius.smAll,
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      dayNum,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
