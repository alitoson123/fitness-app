import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/day_availability.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/availability_selector/availability_helper.dart';
import '../../../../generated/l10n.dart';
import 'time_slot_picker_box.dart';

class TimeSlotConfigurator extends StatelessWidget {
  final DayAvailability availability;
  final int sessionDurationMinutes;
  final ValueChanged<bool> onToggleAvailable;
  final ValueChanged<TimeOfDay> onFromTimeChanged;
  final ValueChanged<TimeOfDay> onToTimeChanged;
  final VoidCallback onApplyToAllDays;

  const TimeSlotConfigurator({
    super.key,
    required this.availability,
    required this.sessionDurationMinutes,
    required this.onToggleAvailable,
    required this.onFromTimeChanged,
    required this.onToTimeChanged,
    required this.onApplyToAllDays,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final isAvail = availability.isAvailable;
    final dayTitle = AvailabilityHelper.getDayFullName(context, availability.day);

    final startMin = availability.fromTime.hour * 60 + availability.fromTime.minute;
    final endMin = availability.toTime.hour * 60 + availability.toTime.minute;
    final diff = endMin > startMin ? endMin - startMin : 0;
    final totalHours = (diff / 60.0).toStringAsFixed(1);
    final sessions = sessionDurationMinutes > 0 ? (diff / sessionDurationMinutes).floor() : 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dayTitle,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                ),
              ),
              Switch(
                value: isAvail,
                activeThumbColor: primary,
                onChanged: onToggleAvailable,
              ),
            ],
          ),
          Text(
            isAvail ? s.dayStatusAvailable : s.dayStatusOff,
            style: TextStyle(
              fontSize: 12.sp,
              color: isAvail ? AppColors.success : textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (isAvail) ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                TimeSlotPickerBox(
                  label: s.startTime,
                  time: availability.fromTime,
                  enabled: true,
                  onTimeChanged: onFromTimeChanged,
                ),
                SizedBox(width: 12.w),
                TimeSlotPickerBox(
                  label: s.endTime,
                  time: availability.toTime,
                  enabled: true,
                  onTimeChanged: onToTimeChanged,
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 15.r, color: textSecondary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    '${s.totalDurationLabel(totalHours)} (${s.approximateSessionsCount(sessions)})',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: onApplyToAllDays,
                icon: Icon(Icons.copy_rounded, size: 14.r, color: primary),
                label: Text(
                  s.applyToAllActiveDays,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: primary,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
