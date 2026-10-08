import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../models/day_availability.dart';
import 'availability_day_card.dart';
import 'availability_day_chips.dart';

class AvailabilitySelector extends StatelessWidget {
  final List<DayAvailability> schedule;
  final ValueChanged<List<DayAvailability>> onScheduleChanged;

  const AvailabilitySelector({
    super.key,
    required this.schedule,
    required this.onScheduleChanged,
  });

  void _toggleDay(DayOfWeek day) {
    final updated = schedule.map((d) {
      if (d.day == day) {
        return d.copyWith(isAvailable: !d.isAvailable);
      }
      return d;
    }).toList();
    onScheduleChanged(updated);
  }

  void _setAvailable(DayOfWeek day, bool available) {
    final updated = schedule.map((d) {
      if (d.day == day) {
        return d.copyWith(isAvailable: available);
      }
      return d;
    }).toList();
    onScheduleChanged(updated);
  }

  void _updateFromTime(DayOfWeek day, TimeOfDay time) {
    final updated = schedule.map((d) {
      if (d.day == day) {
        return d.copyWith(fromTime: time);
      }
      return d;
    }).toList();
    onScheduleChanged(updated);
  }

  void _updateToTime(DayOfWeek day, TimeOfDay time) {
    final updated = schedule.map((d) {
      if (d.day == day) {
        return d.copyWith(toTime: time);
      }
      return d;
    }).toList();
    onScheduleChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.flameRed : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).selectDaysAndHours,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        AvailabilityDayChips(
          schedule: schedule,
          isDark: isDark,
          primaryColor: primaryColor,
          onToggleDay: _toggleDay,
        ),
        SizedBox(height: 16.h),
        ...DayOfWeek.values.map((day) {
          final item = schedule.firstWhere(
            (d) => d.day == day,
            orElse: () => DayAvailability(day: day),
          );
          return AvailabilityDayCard(
            availability: item,
            isDark: isDark,
            primaryColor: primaryColor,
            onToggleAvailable: (val) => _setAvailable(day, val),
            onFromTimeChanged: (t) => _updateFromTime(day, t),
            onToTimeChanged: (t) => _updateToTime(day, t),
          );
        }),
      ],
    );
  }
}
