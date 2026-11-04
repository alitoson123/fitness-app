import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../features/coach_setup/data/models/sport_location_model.dart';
import '../../features/coach_setup/presentation/helpers/coach_setup_localization_helper.dart';
import '../../generated/l10n.dart';
import '../helpers/sport_icon_helper.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import 'sport_delivery_badge.dart';

class SportCarouselCard extends StatelessWidget {
  final String sport;
  final SportLocationModel? config;
  final bool isDark;
  final Color primary;
  final double? width;
  final bool hasFixedHeight;

  const SportCarouselCard({
    super.key,
    required this.sport,
    this.config,
    required this.isDark,
    required this.primary,
    this.width,
    this.hasFixedHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final displayName = CoachSetupLocalizationHelper.getLocalizedSport(
      context,
      sport,
    );
    final icon = SportIconHelper.getIcon(sport);
    final isOnline = config?.isOnline ?? false;
    final locations = config?.locations ?? const <String>[];

    final cardBg = isDark
        ? AppColors.darkSurface
        : AppColors.surfaceVariant.withValues(alpha: 0.35);
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Container(
      width: width,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: hasFixedHeight ? MainAxisSize.max : MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: isDark ? 0.16 : 0.10),
                  borderRadius: AppRadius.smAll,
                ),
                child: Icon(icon, size: 16.r, color: primary),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (hasFixedHeight)
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: _buildDeliveryModes(
                  s: s,
                  isOnline: isOnline,
                  locations: locations,
                ),
              ),
            )
          else
            _buildDeliveryModes(s: s, isOnline: isOnline, locations: locations),
        ],
      ),
    );
  }

  Widget _buildDeliveryModes({
    required S s,
    required bool isOnline,
    required List<String> locations,
  }) {
    if (!isOnline && locations.isEmpty) {
      return Text(
        s.noLocationsOrOnlineWarning,
        style: TextStyle(
          fontSize: 11.sp,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      );
    }

    return Wrap(
      spacing: 6.w,
      runSpacing: 5.h,
      children: [
        if (isOnline)
          SportDeliveryBadge(
            icon: Icons.laptop_chromebook_rounded,
            label: s.onlineAvailableBadge,
            color: primary,
            isDark: isDark,
            isPrimaryStyle: true,
          ),
        ...locations.map(
          (loc) => SportDeliveryBadge(
            icon: Icons.location_on_rounded,
            label: loc,
            color: primary,
            isDark: isDark,
          ),
        ),
      ],
    );
  }
}
