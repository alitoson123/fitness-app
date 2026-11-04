import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/sport_location_model.dart';
import '../../../coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_location_helper.dart';
import '../../../coach_setup/presentation/widgets/sport_location_config_card.dart';

class EditSportLocationsSection extends StatelessWidget {
  final List<String> sports;
  final List<SportLocationModel> sportLocations;
  final ValueChanged<List<SportLocationModel>> onLocationsChanged;

  const EditSportLocationsSection({
    super.key,
    required this.sports,
    required this.sportLocations,
    required this.onLocationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();

    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s.editSportLocations,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
        ),
        SizedBox(height: 10.h),
        ...sports.map((sport) {
          final config =
              CoachSetupLocationHelper.getLocationConfig(
                sportLocations,
                sport,
              ) ??
              SportLocationModel(sport: sport);

          return SportLocationConfigCard(
            config: config,
            onToggleOnline: (val) {
              final updated = CoachSetupLocationHelper.toggleOnline(
                sportLocations,
                sport,
                val,
              );
              onLocationsChanged(updated);
            },
            onAddLocation: (loc) {
              final updated = CoachSetupLocationHelper.addLocation(
                sportLocations,
                sport,
                loc,
              );
              onLocationsChanged(updated);
            },
            onRemoveLocation: (idx) {
              final updated = CoachSetupLocationHelper.removeLocation(
                sportLocations,
                sport,
                idx,
              );
              onLocationsChanged(updated);
            },
            isDark: isDark,
            primary: primary,
          );
        }),
      ],
    );
  }
}
