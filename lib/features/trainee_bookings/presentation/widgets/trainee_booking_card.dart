import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/core/widgets/app_avatar.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/coach_dashboard/presentation/widgets/booking_status_badge.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'trainee_cancelled_booking_section.dart';
import 'trainee_rejected_booking_section.dart';
import 'trainee_reschedule_alert_box.dart';

class TraineeBookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isActionInProgress;
  final VoidCallback onApproveReschedule;
  final VoidCallback onRejectReschedule;
  final VoidCallback onRebook;

  const TraineeBookingCard({
    super.key,
    required this.booking,
    this.isActionInProgress = false,
    required this.onApproveReschedule,
    required this.onRejectReschedule,
    required this.onRebook,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReschedule = booking.status == 'reschedule_pending';
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final dateLabel = booking.isMonthly
        ? '${booking.date} (${s.monthlyPackageType}${booking.sessions.length > 1 ? ' • ${booking.sessions.length}' : ''})'
        : '${booking.date} (${booking.startTime} - ${booking.endTime})';
    final locationLabel = booking.isOnline
        ? s.onlineTrainingOption
        : booking.trainingLocation;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.mdAll,
        border: Border.all(
          color: isReschedule
              ? const Color(0xFFF59E0B)
              : (isDark ? AppColors.darkBorder : AppColors.border),
          width: isReschedule ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(imageUrl: booking.coachPhotoUrl, name: booking.coachName, size: AppAvatarSize.md),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.coachName.isNotEmpty ? booking.coachName : s.coachNavDashboard,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Text(
                          booking.sport,
                          style: TextStyle(fontSize: 11.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
                        ),
                        if (locationLabel.isNotEmpty) ...[
                          Text(' • ', style: TextStyle(fontSize: 11.sp, color: textSecondary)),
                          Icon(
                            booking.isOnline ? Icons.laptop_chromebook_rounded : Icons.location_on_rounded,
                            size: 11.r,
                            color: textSecondary,
                          ),
                          SizedBox(width: 2.w),
                          Flexible(
                            child: Text(
                              locationLabel,
                              style: TextStyle(fontSize: 11.sp, color: textSecondary, fontWeight: FontWeight.w500),
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
                status: booking.status,
                customLabel: isReschedule ? s.rescheduleRequestedBadge : null,
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 13.r, color: textSecondary),
              SizedBox(width: 6.w),
              Text(dateLabel, style: TextStyle(fontSize: 12.sp, color: textSecondary)),
            ],
          ),
          if (isReschedule) ...[
            SizedBox(height: 12.h),
            TraineeRescheduleAlertBox(
              booking: booking,
              isDark: isDark,
              isActionInProgress: isActionInProgress,
              onApprove: onApproveReschedule,
              onReject: onRejectReschedule,
            ),
          ],
          if (booking.status == 'cancelled')
            TraineeCancelledBookingSection(cancellationReason: booking.cancellationReason, onRebook: onRebook),
          if (booking.status == 'rejected')
            TraineeRejectedBookingSection(rejectionReason: booking.rejectionReason, onRebook: onRebook),
        ],
      ),
    );
  }
}
