import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/sport_delivery_carousel.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/sport_location_model.dart';

class CoachSportsTags extends StatelessWidget {
  final List<String> sports;
  final List<SportLocationModel> sportLocations;

  const CoachSportsTags({
    super.key,
    required this.sports,
    this.sportLocations = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (sports.isEmpty) return const SizedBox.shrink();

    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Icon(Icons.sports_score_rounded, size: 18.r, color: primary),
              SizedBox(width: 8.w),
              Text(
                s.sportsAndLocationsTitle,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SportDeliveryCarousel(
          sports: sports,
          sportLocations: sportLocations,
          isDark: isDark,
          primary: primary,
          margin: EdgeInsets.zero,
        ),
      ],
    );
  }
}
