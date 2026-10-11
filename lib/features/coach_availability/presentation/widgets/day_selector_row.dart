import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/day_availability.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/availability_selector/availability_helper.dart';

class DaySelectorRow extends StatelessWidget {
  final List<DayAvailability> schedule;
  final DayOfWeek selectedDay;
  final ValueChanged<DayOfWeek> onSelectDay;

  const DaySelectorRow({
    super.key,
    required this.schedule,
    required this.selectedDay,
    required this.onSelectDay,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: DayOfWeek.values.map((day) {
          final item = schedule.firstWhere(
            (d) => d.day == day,
            orElse: () => DayAvailability(day: day),
          );
          final isSelected = day == selectedDay;
          final isAvailable = item.isAvailable;

          return Padding(
            padding: EdgeInsetsDirectional.only(end: 8.w),
            child: InkWell(
              onTap: () => onSelectDay(day),
              borderRadius: AppRadius.mdAll,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary.withValues(alpha: 0.15)
                      : (isDark ? AppColors.darkSurface : Colors.white),
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AvailabilityHelper.getDayShortName(context, day),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? primary
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      width: 6.r,
                      height: 6.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isAvailable ? AppColors.success : AppColors.neutral400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
