import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class EditProfileSportsChips extends StatelessWidget {
  final List<String> selectedSports;
  final ValueChanged<List<String>> onChanged;

  const EditProfileSportsChips({
    super.key,
    required this.selectedSports,
    required this.onChanged,
  });

  void _toggle(String sport) {
    final list = List<String>.from(selectedSports);
    if (list.contains(sport)) {
      if (list.length > 1) {
        list.remove(sport);
        onChanged(list);
      }
    } else {
      list.add(sport);
      onChanged(list);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.selectSportsPrompt,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: AppConstants.sports.map((sport) {
            final isSelected = selectedSports.contains(sport);
            return ChoiceChip(
              label: Text(sport),
              selected: isSelected,
              onSelected: (_) => _toggle(sport),
              selectedColor: AppColors.primary,
              backgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              labelStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
              ),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.fullAll),
            );
          }).toList(),
        ),
      ],
    );
  }
}

