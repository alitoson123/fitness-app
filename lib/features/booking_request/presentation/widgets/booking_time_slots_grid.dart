import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class BookingTimeSlotsGrid extends StatelessWidget {
  final List<String> slots;
  final String? selectedSlot;
  final bool isLoading;
  final ValueChanged<String> onSelectSlot;

  const BookingTimeSlotsGrid({
    super.key,
    required this.slots,
    required this.selectedSlot,
    required this.isLoading,
    required this.onSelectSlot,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final unselectedBg = isDark ? AppColors.darkSurface : AppColors.neutral100;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).selectTrainingTime,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        if (isLoading)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: Center(
              child: SizedBox(
                width: 24.r,
                height: 24.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
              ),
            ),
          )
        else if (slots.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: unselectedBg,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: border),
            ),
            child: Center(
              child: Text(
                S.of(context).noAvailableSlotsForDate,
                style: TextStyle(fontSize: 13.sp, color: textSecondary),
              ),
            ),
          )
        else
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: slots.map((slot) {
              final isSelected = slot == selectedSlot;
              return InkWell(
                borderRadius: AppRadius.smAll,
                onTap: () => onSelectSlot(slot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? primary : unselectedBg,
                    borderRadius: AppRadius.smAll,
                    border: Border.all(
                      color: isSelected ? primary : border,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14.r,
                        color: isSelected ? Colors.white : textSecondary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        slot,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? Colors.white : textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
