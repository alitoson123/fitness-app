import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../generated/l10n.dart';
import '../../models/day_availability.dart';
import 'availability_helper.dart';
import 'availability_time_picker_box.dart';

class AvailableDayCard extends StatelessWidget {
  final DayAvailability availability;
  final bool isDark;
  final Color primaryColor;
  final VoidCallback onDisable;
  final ValueChanged<TimeOfDay> onFromTimeChanged;
  final ValueChanged<TimeOfDay> onToTimeChanged;

  const AvailableDayCard({
    super.key,
    required this.availability,
    required this.isDark,
    required this.primaryColor,
    required this.onDisable,
    required this.onFromTimeChanged,
    required this.onToTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = AvailabilityHelper.getDayFullName(
      context,
      availability.day,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7.r,
                    height: 7.r,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onDisable,
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF132D21)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF1B4D36)
                          : const Color(0xFFA5D6A7),
                    ),
                  ),
                  child: Text(
                    S.of(context).available,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: AvailabilityTimePickerBox(
                  label: S.of(context).fromTime,
                  time: availability.fromTime,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  onTimeChanged: onFromTimeChanged,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
                child: Icon(
                  Icons.access_time_outlined,
                  size: 15.r,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              Expanded(
                child: AvailabilityTimePickerBox(
                  label: S.of(context).toTime,
                  time: availability.toTime,
                  isDark: isDark,
                  primaryColor: primaryColor,
                  onTimeChanged: onToTimeChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
