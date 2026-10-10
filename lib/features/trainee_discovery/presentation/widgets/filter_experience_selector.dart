import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class FilterExperienceSelector extends StatelessWidget {
  final int selectedExperience;
  final ValueChanged<int> onChanged;

  const FilterExperienceSelector({
    super.key,
    required this.selectedExperience,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final options = [
      (0, S.of(context).anyExperience),
      (1, '1+ yrs'),
      (3, '3+ yrs'),
      (5, '5+ yrs'),
      (10, '10+ yrs'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).minExperienceYears,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: options.map((item) {
            final years = item.$1;
            final label = item.$2;
            final isSelected = selectedExperience == years;

            return InkWell(
              onTap: () => onChanged(years),
              borderRadius: AppRadius.mdAll,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primary
                      : (isDark ? AppColors.darkSurfaceVariant : AppColors.surface),
                  borderRadius: AppRadius.mdAll,
                  border: Border.all(
                    color: isSelected
                        ? primary
                        : (isDark ? AppColors.darkBorder : AppColors.border),
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
