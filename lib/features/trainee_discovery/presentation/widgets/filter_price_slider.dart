import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';

class FilterPriceSlider extends StatelessWidget {
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;

  const FilterPriceSlider({
    super.key,
    required this.range,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).priceRange,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            Text(
              '${range.start.round()} - ${range.end.round()} SAR',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        RangeSlider(
          values: range,
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: primary,
          inactiveColor:
              isDark ? AppColors.darkSurfaceVariant : AppColors.border,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0 SAR',
              style: TextStyle(fontSize: 11.sp, color: textSecondary),
            ),
            Text(
              '1000+ SAR',
              style: TextStyle(fontSize: 11.sp, color: textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
