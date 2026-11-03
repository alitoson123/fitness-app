import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class EditTraineeGenderSelector extends StatelessWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  const EditTraineeGenderSelector({
    super.key,
    required this.selectedGender,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final isMale = selectedGender.toLowerCase() == 'male';
    final isFemale = selectedGender.toLowerCase() == 'female';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.reviewGender,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            ChoiceChip(
              label: Text(s.male),
              selected: isMale,
              onSelected: (_) => onGenderChanged('male'),
              selectedColor: AppColors.primary,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: isMale ? FontWeight.w700 : FontWeight.w500,
                color: isMale ? Colors.white : textSecondary,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
            ),
            SizedBox(width: 10.w),
            ChoiceChip(
              label: Text(s.female),
              selected: isFemale,
              onSelected: (_) => onGenderChanged('female'),
              selectedColor: AppColors.primary,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: isFemale ? FontWeight.w700 : FontWeight.w500,
                color: isFemale ? Colors.white : textSecondary,
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
            ),
          ],
        ),
      ],
    );
  }
}

