import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class SlotDurationPicker extends StatelessWidget {
  final int selectedDurationMinutes;
  final ValueChanged<int> onDurationChanged;

  static const List<int> supportedDurations = [30, 45, 60, 90, 120];

  const SlotDurationPicker({
    super.key,
    required this.selectedDurationMinutes,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.timer_outlined, size: 18.r, color: primary),
            SizedBox(width: 8.w),
            Text(
              S.of(context).sessionDuration,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          S.of(context).availabilitySubtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: textSecondary,
          ),
        ),
        SizedBox(height: 12.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: supportedDurations.map((duration) {
              final isSelected = duration == selectedDurationMinutes;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 8.w),
                child: ChoiceChip(
                  label: Text(S.of(context).minutesDuration(duration)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onDurationChanged(duration);
                  },
                  selectedColor: primary,
                  backgroundColor:
                      isDark ? AppColors.darkSurface : Colors.white,
                  labelStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mdAll,
                    side: BorderSide(
                      color: isSelected
                          ? primary
                          : (isDark
                              ? AppColors.darkBorder
                              : AppColors.border),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
