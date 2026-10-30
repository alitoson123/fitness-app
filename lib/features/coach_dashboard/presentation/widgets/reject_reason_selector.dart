import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class RejectReasonSelector extends StatelessWidget {
  final List<(String key, String label)> reasons;
  final String selectedKey;
  final ValueChanged<String> onSelect;

  const RejectReasonSelector({
    super.key,
    required this.reasons,
    required this.selectedKey,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: reasons.map((entry) {
        final isSelected = entry.$1 == selectedKey;
        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: InkWell(
            onTap: () => onSelect(entry.$1),
            borderRadius: AppRadius.smAll,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.error.withValues(alpha: 0.08)
                    : (isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.surfaceVariant),
                borderRadius: AppRadius.smAll,
                border: Border.all(
                  color: isSelected
                      ? AppColors.error
                      : (isDark ? AppColors.darkBorder : AppColors.border),
                  width: isSelected ? 1.5 : 1.0,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_off_rounded,
                    size: 16.r,
                    color: isSelected
                        ? AppColors.error
                        : (isDark
                            ? AppColors.darkTextTertiary
                            : AppColors.textTertiary),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      entry.$2,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

