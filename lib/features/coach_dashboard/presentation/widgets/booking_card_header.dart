import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'booking_card_header_badge.dart';
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
    final s = S.of(context);
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final badgeBg =
        isDark ? AppColors.darkBackground : AppColors.backgroundSecondary;

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
              Row(
                children: [
                  Flexible(
                    child: BookingCardHeaderBadge(
                      icon: Icons.fitness_center_rounded,
                      label: booking.sport,
                      iconColor: AppColors.flameRed,
                      textColor: AppColors.flameRed,
                      bg: badgeBg,
                    ),
                  ),
                  if (booking.isOnline ||
                      booking.trainingLocation.isNotEmpty) ...[
                    SizedBox(width: 4.w),
                    Flexible(
                      child: BookingCardHeaderBadge(
                        icon: booking.isOnline
                            ? Icons.laptop_chromebook_rounded
                            : Icons.location_on_rounded,
                        label: booking.isOnline
                            ? 'Online'
                            : booking.trainingLocation,
                        iconColor: textSecondary,
                        textColor: textSecondary,
                        bg: badgeBg,
                      ),
                    ),
                  ],
                ],
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
              BookingStatusBadge(
                status: booking.status,
                customLabel: booking.isReschedulePending
                    ? (booking.rescheduledBy == AppConstants.roleTrainee
                        ? s.rescheduleRequestedBadge
                        : s.reschedulePendingBadge)
                    : null,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
