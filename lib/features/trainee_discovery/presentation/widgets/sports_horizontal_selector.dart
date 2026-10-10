import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class SportsHorizontalSelector extends StatelessWidget {
  final String? selectedSport;
  final ValueChanged<String?> onSportSelected;

  const SportsHorizontalSelector({
    super.key,
    required this.selectedSport,
    required this.onSportSelected,
  });

  IconData _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'gym':
        return Icons.fitness_center_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'boxing':
        return Icons.sports_mma_rounded;
      case 'swimming':
        return Icons.pool_rounded;
      case 'basketball':
        return Icons.sports_basketball_rounded;
      case 'tennis':
        return Icons.sports_tennis_rounded;
      case 'volleyball':
        return Icons.sports_volleyball_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final allCategories = [null, ...AppConstants.sports];

    return SizedBox(
      height: 44.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: allCategories.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final sport = allCategories[index];
          final isSelected = sport == null
              ? (selectedSport == null || selectedSport!.isEmpty)
              : selectedSport?.toLowerCase() == sport.toLowerCase();

          final label = sport ?? S.of(context).allSports;
          final icon = sport == null
              ? Icons.grid_view_rounded
              : _getSportIcon(sport);

          return _SportCategoryChip(
            label: label,
            icon: icon,
            isSelected: isSelected,
            primaryColor: primary,
            isDark: isDark,
            onTap: () => onSportSelected(sport),
          );
        },
      ),
    );
  }
}

class _SportCategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color primaryColor;
  final bool isDark;
  final VoidCallback onTap;

  const _SportCategoryChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.primaryColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? primaryColor
        : (isDark ? AppColors.darkSurfaceVariant : AppColors.surface);
    final fgColor = isSelected
        ? Colors.white
        : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary);
    final borderColor = isSelected
        ? primaryColor
        : (isDark ? AppColors.darkBorder : AppColors.border);

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.fullAll,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.fullAll,
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.r, color: fgColor),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: fgColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
