import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_details/presentation/view_model/booking_details_args.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../coach_dashboard/presentation/widgets/booking_card_compact_progress.dart';
import '../view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import 'trainee_booking_card_header.dart';
import 'trainee_cancelled_booking_section.dart';
import 'trainee_monthly_reschedule_alert_box.dart';
import 'trainee_rejected_booking_section.dart';
import 'trainee_reschedule_alert_box.dart';
import 'trainee_reschedule_pending_coach_box.dart';

class TraineeBookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isActionInProgress;
  final VoidCallback onApproveReschedule;
  final VoidCallback onRejectReschedule;
  final VoidCallback onRebook;
  final VoidCallback? onReschedule;
  final void Function(String sessionId)? onAcceptMonthlyReschedule;
  final void Function(String sessionId)? onDeclineMonthlyReschedule;

  const TraineeBookingCard({
    super.key,
    required this.booking,
    this.isActionInProgress = false,
    required this.onApproveReschedule,
    required this.onRejectReschedule,
    required this.onRebook,
    this.onReschedule,
    this.onAcceptMonthlyReschedule,
    this.onDeclineMonthlyReschedule,
  });

  void _navigateToDetails(BuildContext context) {
    context.push(
      AppRoutes.bookingDetails,
      extra: BookingDetailsArgs(booking: booking, isCoach: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<TraineeBookingsCubit>();
    final isReschedule = booking.status == 'reschedule_pending';
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final dateLabel = booking.isMonthly
        ? '${booking.date} (${s.monthlyPackageType}${booking.sessions.length > 1 ? ' • ${booking.sessions.length}' : ''})'
        : '${booking.date} (${booking.startTime} - ${booking.endTime})';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadius.mdAll,
          onTap: () => _navigateToDetails(context),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TraineeBookingCardHeader(booking: booking, isDark: isDark),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 13.r,
                      color: textSecondary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      dateLabel,
                      style: TextStyle(fontSize: 12.sp, color: textSecondary),
                    ),
                  ],
                ),
                if (booking.isMonthly)
                  BookingCardCompactProgress(
                    booking: booking,
                    isDark: isDark,
                  ),
                if (booking.isMonthly &&
                    booking.hasPendingSessionReschedule) ...[
                  SizedBox(height: 12.h),
                  TraineeMonthlyRescheduleAlertBox(
                    booking: booking,
                    isDark: isDark,
                    isActionInProgress: isActionInProgress,
                    onAccept: onAcceptMonthlyReschedule ??
                        (sid) => cubit.acceptMonthlySessionReschedule(
                              booking.id,
                              sid,
                            ),
                    onDecline: onDeclineMonthlyReschedule ??
                        (sid) => cubit.declineMonthlySessionReschedule(
                              booking.id,
                              sid,
                            ),
                  ),
                ] else if (isReschedule && !booking.isMonthly) ...[
                  SizedBox(height: 12.h),
                  if (booking.rescheduledBy == AppConstants.roleTrainee)
                    TraineeReschedulePendingCoachBox(
                      booking: booking,
                      isDark: isDark,
                    )
                  else
                    TraineeRescheduleAlertBox(
                      booking: booking,
                      isDark: isDark,
                      isActionInProgress: isActionInProgress,
                      onApprove: onApproveReschedule,
                      onReject: onRejectReschedule,
                    ),
                ],
                if (booking.status == 'confirmed' &&
                    !booking.isMonthly &&
                    onReschedule != null) ...[
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isActionInProgress ? null : onReschedule,
                      icon: Icon(Icons.schedule_rounded, size: 14.r),
                      label: Text(
                        s.rescheduleSession,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: AppColors.primary.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.smAll,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                    ),
                  ),
                ],
                if (booking.status == 'cancelled')
                  TraineeCancelledBookingSection(
                    cancellationReason: booking.cancellationReason,
                    onRebook: onRebook,
                  ),
                if (booking.status == 'rejected')
                  TraineeRejectedBookingSection(
                    rejectionReason: booking.rejectionReason,
                    onRebook: onRebook,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
