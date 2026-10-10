import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/discovery_sort_option.dart';

class FilterSortSelector extends StatelessWidget {
  final DiscoverySortOption selectedSort;
  final ValueChanged<DiscoverySortOption> onChanged;

  const FilterSortSelector({
    super.key,
    required this.selectedSort,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    final options = [
      (DiscoverySortOption.recommended, S.of(context).sortRecommended),
      (DiscoverySortOption.ratingHighToLow, S.of(context).sortRatingHighToLow),
      (DiscoverySortOption.priceLowToHigh, S.of(context).sortPriceLowToHigh),
      (DiscoverySortOption.priceHighToLow, S.of(context).sortPriceHighToLow),
      (DiscoverySortOption.experienceHighToLow, S.of(context).sortExperienceHighToLow),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).sortBy,
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
            final sort = item.$1;
            final label = item.$2;
            final isSelected = selectedSort == sort;

            return InkWell(
              onTap: () => onChanged(sort),
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
