import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/sport_location_model.dart';
import '../../../coach_setup/presentation/helpers/coach_setup_localization_helper.dart';

class CoachCardSportsRow extends StatelessWidget {
  final List<String> sports;
  final List<SportLocationModel> sportLocations;
  final Color primaryColor;
  final bool isDark;

  const CoachCardSportsRow({
    super.key,
    required this.sports,
    this.sportLocations = const [],
    required this.primaryColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();
    final s = S.of(context);
    final visibleSports = sports.take(2).toList();
    final remaining = sports.length - visibleSports.length;

    final hasOnline = sportLocations.any((l) => l.isOnline);
    final totalLocations = sportLocations.fold<int>(
      0,
      (acc, l) => acc + l.locations.length,
    );

    return Wrap(
      spacing: 6.w,
      runSpacing: 4.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...visibleSports.map(
          (sport) => Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: AppRadius.smAll,
            ),
            child: Text(
              CoachSetupLocalizationHelper.getLocalizedSport(context, sport),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
        if (remaining > 0)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.surfaceVariant,
              borderRadius: AppRadius.smAll,
            ),
            child: Text(
              '+$remaining',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        if (hasOnline)
          _buildDeliveryBadge(
            icon: Icons.laptop_chromebook_rounded,
            label: s.onlineAvailableBadge,
          ),
        if (totalLocations > 0)
          _buildDeliveryBadge(
            icon: Icons.location_on_rounded,
            label: s.locationsCount(totalLocations),
          ),
      ],
    );
  }

  Widget _buildDeliveryBadge({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant.withValues(alpha: 0.7)
            : AppColors.surfaceVariant,
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10.r,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
