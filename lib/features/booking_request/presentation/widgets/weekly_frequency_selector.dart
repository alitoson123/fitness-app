import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class WeeklyFrequencySelector extends StatelessWidget {
  final int selectedFrequency;
  final ValueChanged<int> onFrequencySelected;

  const WeeklyFrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencySelected,
  });

  static const List<int> frequencies = [2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.repeat_rounded, size: 16.r, color: primary),
            SizedBox(width: 6.w),
            Text(
              s.weeklyFrequencyLabel,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: frequencies.map((freq) {
            final isSelected = freq == selectedFrequency;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: _FrequencyChip(
                  count: freq,
                  isSelected: isSelected,
                  onTap: () => onFrequencySelected(freq),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FrequencyChip extends StatelessWidget {
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyChip({
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final border = isSelected
        ? primary
        : (isDark ? AppColors.darkBorder : AppColors.border);
    final bg = isSelected
        ? primary
        : (isDark ? AppColors.darkSurface : Colors.white);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.smAll,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.smAll,
          border: Border.all(color: border),
        ),
        child: Text(
          s.daysPerWeekCount(count),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

