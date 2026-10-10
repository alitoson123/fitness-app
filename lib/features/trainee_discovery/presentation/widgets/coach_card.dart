import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'coach_card_avatar.dart';
import 'coach_card_rating_row.dart';
import 'coach_card_sports_row.dart';

class CoachCard extends StatelessWidget {
  final CoachProfileModel coach;
  final VoidCallback onTap;

  const CoachCard({
    super.key,
    required this.coach,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.lgAll,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgAll,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoachCardAvatar(photoUrl: coach.photoUrl, name: coach.name),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              coach.name.isNotEmpty
                                  ? coach.name
                                  : S.of(context).verifiedCoach,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.verified_rounded,
                            size: 16.r,
                            color: primary,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      CoachCardRatingRow(
                        rating: coach.rating,
                        reviewsCount: coach.reviewsCount,
                        yearsOfExperience: coach.yearsOfExperience,
                        primaryColor: primary,
                        textSecondaryColor: textSecondary,
                      ),
                      SizedBox(height: 8.h),
                      CoachCardSportsRow(
                        sports: coach.sports,
                        primaryColor: primary,
                        isDark: isDark,
                      ),
                      SizedBox(height: 8.h),
                      _buildPriceRow(context, primary, textPrimary),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(
    BuildContext context,
    Color primary,
    Color textPrimary,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${coach.sessionPrice.toStringAsFixed(0)} ${coach.currency} ${S.of(context).perSessionUnit}',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          size: 13.r,
          color: textPrimary.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
