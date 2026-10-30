import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';

class BookingTypeCard extends StatelessWidget {
  final String title;
  final String priceText;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const BookingTypeCard({
    super.key,
    required this.title,
    required this.priceText,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    final bg = isSelected
        ? primary.withValues(alpha: isDark ? 0.2 : 0.08)
        : (isDark ? AppColors.darkSurface : Colors.white);
    final border = isSelected
        ? primary
        : (isDark ? AppColors.darkBorder : AppColors.border);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.mdAll,
          border: Border.all(color: border, width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18.r, color: isSelected ? primary : textSecondary),
                const Spacer(),
                if (isSelected)
                  Icon(Icons.check_circle_rounded, size: 18.r, color: primary),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  priceText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    subtitle,
                    style: TextStyle(fontSize: 10.sp, color: textSecondary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

