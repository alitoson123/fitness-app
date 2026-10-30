import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class RescheduleTimeSlots extends StatelessWidget {
  final List<String> availableSlots;
  final String? selectedSlot;
  final ValueChanged<String> onSelectSlot;
  final bool isLoading;

  const RescheduleTimeSlots({
    super.key,
    required this.availableSlots,
    required this.selectedSlot,
    required this.onSelectSlot,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: const CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (availableSlots.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(
          S.of(context).noAvailableSlotsForDay,
          style: TextStyle(
            fontSize: 12.sp,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: availableSlots.map((slot) {
        final isSelected = slot == selectedSlot;
        return InkWell(
          onTap: () => onSelectSlot(slot),
          borderRadius: AppRadius.smAll,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkSurfaceVariant : Colors.white),
              borderRadius: AppRadius.smAll,
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkBorder : AppColors.border),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
