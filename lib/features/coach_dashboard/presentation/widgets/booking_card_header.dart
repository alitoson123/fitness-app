import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'booking_status_badge.dart';

class BookingCardHeader extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;

  const BookingCardHeader({
    super.key,
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.r,
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
                    fontSize: 13.sp,
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
                booking.traineeName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBackground
                      : AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.fitness_center_rounded,
                      size: 10.r,
                      color: AppColors.flameRed,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      booking.sport,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.flameRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${booking.price.toInt()} ${booking.currency}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            if (booking.status != 'pending') ...[
              SizedBox(height: 4.h),
              BookingStatusBadge(status: booking.status),
            ],
          ],
        ),
      ],
    );
  }
}
