import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../helpers/training_insights_calculator.dart';

class TrainingInsightsPeriodSelector extends StatelessWidget {
  final TrainingPeriod selectedPeriod;
  final ValueChanged<TrainingPeriod> onPeriodSelected;

  const TrainingInsightsPeriodSelector({
    super.key,
    required this.selectedPeriod,
    required this.onPeriodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.surfaceVariant,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        children: [
          _TabItem(
            title: s.periodDay,
            isSelected: selectedPeriod == TrainingPeriod.day,
            onTap: () => onPeriodSelected(TrainingPeriod.day),
            isDark: isDark,
          ),
          _TabItem(
            title: s.periodMonth,
            isSelected: selectedPeriod == TrainingPeriod.month,
            onTap: () => onPeriodSelected(TrainingPeriod.month),
            isDark: isDark,
          ),
          _TabItem(
            title: s.periodYear,
            isSelected: selectedPeriod == TrainingPeriod.year,
            onTap: () => onPeriodSelected(TrainingPeriod.year),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkSurface : Colors.white)
                : Colors.transparent,
            borderRadius: AppRadius.smAll,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? AppColors.primary
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

