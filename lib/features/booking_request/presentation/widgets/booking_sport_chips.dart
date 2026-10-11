import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class BookingSportChips extends StatelessWidget {
  final List<String> sports;
  final String? selectedSport;
  final ValueChanged<String> onSelectSport;

  const BookingSportChips({
    super.key,
    required this.sports,
    required this.selectedSport,
    required this.onSelectSport,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final unselectedBg = isDark ? AppColors.darkSurface : AppColors.neutral100;
    final border = isDark ? AppColors.darkBorder : AppColors.border;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).selectTrainingSport,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: sports.map((sport) {
            final isSelected = sport == selectedSport;
            return InkWell(
              borderRadius: AppRadius.smAll,
              onTap: () => onSelectSport(sport),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? primary : unselectedBg,
                  borderRadius: AppRadius.smAll,
                  border: Border.all(
                    color: isSelected ? primary : border,
                    width: 1.2,
                  ),
                ),
                child: Text(
                  sport,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : textPrimary,
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
