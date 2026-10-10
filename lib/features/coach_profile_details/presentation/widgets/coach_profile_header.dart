import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/widgets/app_avatar.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'coach_personal_badges.dart';
import 'coach_sports_tags.dart';

class CoachProfileHeader extends StatelessWidget {
  final CoachProfileModel coach;

  const CoachProfileHeader({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final location = _formatLocation(coach.city, coach.country);
    final hasPersonalMeta = coach.gender.isNotEmpty || coach.age > 0;

    return Column(
      children: [
        Center(
          child: AppAvatar(
            imageUrl: coach.photoUrl,
            name: coach.name,
            size: AppAvatarSize.xl,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                coach.name.isNotEmpty
                    ? coach.name
                    : S.of(context).verifiedCoach,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.verified_rounded, size: 20.r, color: primary),
          ],
        ),
        if (location.isNotEmpty) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 15.r,
                color: textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                location,
                style: TextStyle(fontSize: 13.sp, color: textSecondary),
              ),
            ],
          ),
        ],
        if (hasPersonalMeta) ...[
          SizedBox(height: 8.h),
          CoachPersonalBadges(coach: coach),
        ],
        SizedBox(height: 8.h),
        _buildRatingRow(context, primary, textSecondary),
        SizedBox(height: 12.h),
        CoachSportsTags(
          sports: coach.sports,
          isDark: isDark,
          primary: primary,
        ),
      ],
    );
  }

  String _formatLocation(String city, String country) {
    if (city.isNotEmpty && country.isNotEmpty) return '$city, $country';
    if (city.isNotEmpty) return city;
    return country;
  }

  Widget _buildRatingRow(
    BuildContext context,
    Color primary,
    Color textSecondary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.star_rounded, size: 18.r, color: Colors.amber),
        SizedBox(width: 4.w),
        Text(
          coach.rating > 0 ? coach.rating.toStringAsFixed(1) : '',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          coach.reviewsCount > 0
              ? '(${S.of(context).reviewsCount(coach.reviewsCount)})'
              : '(${S.of(context).noReviewsYet})',
          style: TextStyle(fontSize: 12.sp, color: textSecondary),
        ),
      ],
    );
  }
}
