import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../models/day_availability.dart';
import 'availability_helper.dart';

class AvailabilityDayChips extends StatelessWidget {
  final List<DayAvailability> schedule;
  final bool isDark;
  final Color primaryColor;
  final ValueChanged<DayOfWeek> onToggleDay;

  const AvailabilityDayChips({
    super.key,
    required this.schedule,
    required this.isDark,
    required this.primaryColor,
    required this.onToggleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: DayOfWeek.values.map((day) {
        final item = schedule.firstWhere(
          (d) => d.day == day,
          orElse: () => DayAvailability(day: day),
        );
        final isSelected = item.isAvailable;
        final shortName = AvailabilityHelper.getDayShortName(context, day);

        return Expanded(
          child: GestureDetector(
            onTap: () => onToggleDay(day),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : isDark
                        ? AppColors.darkSurface
                        : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : isDark
                          ? AppColors.darkBorder
                          : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  shortName,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
