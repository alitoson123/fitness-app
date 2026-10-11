import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

class BookingCoachSummaryCard extends StatelessWidget {
  final CoachProfileModel coach;

  const BookingCoachSummaryCard({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textPrimary = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28.r,
            backgroundColor: primary.withValues(alpha: 0.15),
            backgroundImage: coach.photoUrl.isNotEmpty
                ? CachedNetworkImageProvider(coach.photoUrl)
                : null,
            child: coach.photoUrl.isEmpty
                ? Icon(Icons.person, size: 28.r, color: primary)
                : null,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        coach.name.isNotEmpty ? coach.name : 'Coach',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.verified_rounded, size: 16.r, color: primary),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  '${coach.city.isNotEmpty ? coach.city : 'Fitness'}, ${coach.country}',
                  style: TextStyle(fontSize: 12.sp, color: textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 16.r, color: Colors.amber),
                    SizedBox(width: 2.w),
                    Text(
                      coach.rating > 0 ? coach.rating.toStringAsFixed(1) : '(New)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${coach.sessionPrice.toStringAsFixed(0)} ${coach.currency}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
