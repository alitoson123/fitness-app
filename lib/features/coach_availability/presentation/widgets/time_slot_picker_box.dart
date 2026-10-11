import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/availability_selector/availability_helper.dart';

class TimeSlotPickerBox extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final bool enabled;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const TimeSlotPickerBox({
    super.key,
    required this.label,
    required this.time,
    this.enabled = true,
    required this.onTimeChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    if (!enabled) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: time,
    );
    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: textSecondary,
            ),
          ),
          SizedBox(height: 6.h),
          InkWell(
            onTap: enabled ? () => _pickTime(context) : null,
            borderRadius: AppRadius.mdAll,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: enabled ? cardBg : (isDark ? Colors.black12 : AppColors.neutral100),
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AvailabilityHelper.formatTime(context, time),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: enabled
                          ? (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary)
                          : textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.access_time_rounded,
                    size: 16.r,
                    color: enabled ? primary : textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
