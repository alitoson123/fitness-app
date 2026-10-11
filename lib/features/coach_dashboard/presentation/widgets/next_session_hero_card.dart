import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../helpers/coach_booking_date_helper.dart';
import 'booking_card_info.dart';
import 'next_session_hero_header.dart';

class NextSessionHeroCard extends StatelessWidget {
  final BookingModel session;
  final VoidCallback? onTap;

  const NextSessionHeroCard({
    super.key,
    required this.session,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final countdown = CoachBookingDateHelper.formatCountdown(context, session);
    final humanDate = CoachBookingDateHelper.formatHumanDate(
      context,
      session.date,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.lgAll,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.lgAll,
          border: Border.all(
            color: AppColors.success.withValues(alpha: 0.35),
            width: 1.2,
          ),
          gradient: isDark
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.darkSurface,
                    AppColors.success.withValues(alpha: 0.05),
                  ],
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NextSessionHeroHeader(countdown: countdown),
            SizedBox(height: 12.h),
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.flameRed.withValues(alpha: 0.12),
                  backgroundImage: session.traineePhotoUrl.isNotEmpty
                      ? CachedNetworkImageProvider(session.traineePhotoUrl)
                      : null,
                  child: session.traineePhotoUrl.isEmpty
                      ? Text(
                          session.traineeName.isNotEmpty
                              ? session.traineeName[0].toUpperCase()
                              : 'T',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.flameRed,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.traineeName,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        session.sport,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.flameRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            BookingCardInfo(
              dateFormatted: humanDate,
              startTime: session.startTime,
              endTime: session.endTime,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}
