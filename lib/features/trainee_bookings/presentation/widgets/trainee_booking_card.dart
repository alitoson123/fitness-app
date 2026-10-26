import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/core/widgets/app_avatar.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/coach_dashboard/presentation/widgets/booking_status_badge.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final isReschedulePending = booking.status == 'reschedule_pending';
    final isCancelled = booking.status == 'cancelled';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
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
                    Text(
                      booking.sport,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              BookingStatusBadge(status: booking.status),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 13.r,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              SizedBox(width: 6.w),
              Text(
                '${booking.date} (${booking.startTime} - ${booking.endTime})',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (isReschedulePending) ...[
            SizedBox(height: 12.h),
            TraineeRescheduleAlertBox(
              booking: booking,
              isDark: isDark,
              isActionInProgress: isActionInProgress,
              onApprove: onApproveReschedule,
              onReject: onRejectReschedule,
            ),
          ],
          if (isCancelled) ...[
            SizedBox(height: 10.h),
            if (booking.cancellationReason?.isNotEmpty == true)
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  booking.cancellationReason!,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontStyle: FontStyle.italic,
                    color: AppColors.error,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRebook,
                icon: Icon(Icons.refresh_rounded, size: 14.r),
                label: Text(
                  s.bookNewSession,
                  style: TextStyle(fontSize: 12.sp),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
