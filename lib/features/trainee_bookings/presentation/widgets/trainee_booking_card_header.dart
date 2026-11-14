import 'package:fitness_app/features/booking_request/data/repos/booking_actions/booking_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_sports.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../coach_dashboard/presentation/widgets/booking_status_badge.dart';

class TraineeBookingCardHeader extends StatelessWidget {
  final BookingModel booking;
  final bool isDark;

  const TraineeBookingCardHeader({
    super.key,
    required this.booking,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final shownStatus = BookingTransitions.displayStatus(
      booking,
      DateTime.now(),
    );
    final isReschedule = shownStatus == 'reschedule_pending';
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;
    final locationLabel = booking.isOnline
        ? s.onlineTrainingOption
        : booking.trainingLocation;

    return Row(
      children: [
        AppAvatar(
          imageUrl: booking.coachPhotoUrl,
          name: booking.coachName,
          size: AppAvatarSize.md,
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.coachName.isNotEmpty
                    ? booking.coachName
                    : s.coachNavDashboard,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text(
                    AppSports.getLocalizedSportName(context, booking.sport),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (locationLabel.isNotEmpty) ...[
                    Text(
                      ' • ',
                      style: TextStyle(fontSize: 11.sp, color: textSecondary),
                    ),
                    Icon(
                      booking.isOnline
                          ? Icons.laptop_chromebook_rounded
                          : Icons.location_on_rounded,
                      size: 11.r,
                      color: textSecondary,
                    ),
                    SizedBox(width: 2.w),
                    Flexible(
                      child: Text(
                        locationLabel,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        BookingStatusBadge(
          status: shownStatus,
          customLabel: isReschedule ? s.rescheduleRequestedBadge : null,
        ),
      ],
    );
  }
}
