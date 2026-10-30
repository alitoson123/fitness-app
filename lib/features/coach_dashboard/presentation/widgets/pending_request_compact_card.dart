import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../helpers/coach_booking_date_helper.dart';
import 'compact_request_actions.dart';
import 'compact_request_info_row.dart';

class PendingRequestCompactCard extends StatelessWidget {
  final BookingModel booking;
  final bool isActionInProgress;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback? onReschedule;

  const PendingRequestCompactCard({
    super.key,
    required this.booking,
    required this.isActionInProgress,
    required this.onAccept,
    required this.onReject,
    this.onReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dateFormatted = CoachBookingDateHelper.formatHumanDate(
      context,
      booking.date,
    );

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.mdAll,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.flameRed.withValues(alpha: 0.12),
                backgroundImage: booking.traineePhotoUrl.isNotEmpty
                    ? CachedNetworkImageProvider(booking.traineePhotoUrl)
                    : null,
                child: booking.traineePhotoUrl.isEmpty
                    ? Text(
                        booking.traineeName.isNotEmpty
                            ? booking.traineeName[0].toUpperCase()
                            : 'T',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.flameRed,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.traineeName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      booking.sport,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.flameRed,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${booking.price.toInt()} ${booking.currency}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.flameRed,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          CompactRequestInfoRow(
            dateFormatted: dateFormatted,
            startTime: booking.startTime,
            endTime: booking.endTime,
            isDark: isDark,
          ),
          SizedBox(height: 10.h),
          CompactRequestActions(
            isActionInProgress: isActionInProgress,
            onAccept: onAccept,
            onReject: onReject,
            onReschedule: onReschedule,
          ),
        ],
      ),
    );
  }
}
