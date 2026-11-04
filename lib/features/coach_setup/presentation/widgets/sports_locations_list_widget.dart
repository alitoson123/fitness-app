import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/sport_location_model.dart';
import '../view_model/coach_setup_cubit/coach_setup_cubit.dart';
import '../view_model/coach_setup_cubit/coach_setup_location_helper.dart';
import 'sport_location_config_card.dart';

class SportsLocationsListWidget extends StatelessWidget {
  final CoachSetupCubit cubit;

  const SportsLocationsListWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit.selectedSports.isEmpty) return const SizedBox.shrink();

    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.sportDeliveryModeTitle,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          s.sportDeliveryModeSubtitle,
          style: TextStyle(fontSize: 12.sp, color: textSecondary),
        ),
        SizedBox(height: 14.h),
        ...cubit.selectedSports.map((sport) {
          final config =
              CoachSetupLocationHelper.getLocationConfig(
                cubit.sportLocations,
                sport,
              ) ??
              SportLocationModel(sport: sport);

          return SportLocationConfigCard(
            config: config,
            onToggleOnline: (val) => cubit.toggleSportOnline(sport, val),
            onAddLocation: (loc) => cubit.addSportLocation(sport, loc),
            onRemoveLocation: (idx) => cubit.removeSportLocation(sport, idx),
            isDark: isDark,
            primary: primary,
          );
        }),
      ],
    );
  }
}
