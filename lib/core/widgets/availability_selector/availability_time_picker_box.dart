import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import 'availability_helper.dart';

class AvailabilityTimePickerBox extends StatelessWidget {
  final String label;
  final TimeOfDay time;
  final bool isDark;
  final Color primaryColor;
  final ValueChanged<TimeOfDay> onTimeChanged;

  const AvailabilityTimePickerBox({
    super.key,
    required this.label,
    required this.time,
    required this.isDark,
    required this.primaryColor,
    required this.onTimeChanged,
  });

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: Theme.of(ctx).colorScheme.copyWith(
              primary: primaryColor,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedTime = AvailabilityHelper.formatTime(context, time);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 4.h),
        InkWell(
          onTap: () => _pickTime(context),
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBackground : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                Icon(
                  Icons.access_time_rounded,
                  size: 15.r,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
