import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';

class EditTraineeFitnessFields extends StatelessWidget {
  final String selectedLevel;
  final String selectedGoal;
  final ValueChanged<String> onLevelChanged;
  final ValueChanged<String> onGoalChanged;

  const EditTraineeFitnessFields({
    super.key,
    required this.selectedLevel,
    required this.selectedGoal,
    required this.onLevelChanged,
    required this.onGoalChanged,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final levels = [
      {'id': 'beginner', 'label': s.beginner},
      {'id': 'intermediate', 'label': s.intermediate},
      {'id': 'advanced', 'label': s.advanced},
    ];

    final goals = [
      {'id': 'fitness', 'label': s.generalFitness},
      {'id': 'weight_loss', 'label': s.weightLoss},
      {'id': 'competition', 'label': s.competitionPrep},
      {'id': 'skill', 'label': s.skillDevelopment},
      {'id': 'fun', 'label': s.funRecreation},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.selectFitnessLevel,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: levels.map((lvl) {
            final isSelected =
                selectedLevel.toLowerCase() == lvl['id']!.toLowerCase();
            return ChoiceChip(
              label: Text(lvl['label']!),
              selected: isSelected,
              onSelected: (_) => onLevelChanged(lvl['id']!),
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
        SizedBox(height: AppSpacing.s3),
        Text(
          s.selectFitnessGoal,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: goals.map((g) {
            final isSelected =
                selectedGoal.toLowerCase() == g['id']!.toLowerCase();
            return ChoiceChip(
              label: Text(g['label']!),
              selected: isSelected,
              onSelected: (_) => onGoalChanged(g['id']!),
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

