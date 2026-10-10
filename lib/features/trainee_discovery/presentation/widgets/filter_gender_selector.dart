import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class FilterGenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onChanged;

  const FilterGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final options = [
      {'key': 'all', 'label': S.of(context).allGenders},
      {'key': 'male', 'label': S.of(context).maleOnly},
      {'key': 'female', 'label': S.of(context).femaleOnly},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).coachGender,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: options.map((opt) {
            final key = opt['key']!;
            final label = opt['label']!;
            final isSelected = selectedGender == key;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: () => onChanged(key),
                  borderRadius: AppRadius.mdAll,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? primary
                          : (isDark
                              ? AppColors.darkSurfaceVariant
                              : AppColors.surface),
                      borderRadius: AppRadius.mdAll,
                      border: Border.all(
                        color: isSelected
                            ? primary
                            : (isDark
                                ? AppColors.darkBorder
                                : AppColors.border),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
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
