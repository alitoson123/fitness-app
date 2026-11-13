import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/navigator/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_details/presentation/view_model/booking_details_args.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_actions/booking_transitions.dart';
import '../helpers/coach_booking_date_helper.dart';
import 'booking_card_actions.dart';
import 'booking_card_compact_progress.dart';
import 'booking_card_header.dart';
import 'booking_card_info.dart';
import 'booking_card_notes.dart';
import 'booking_card_reschedule_info.dart';
import 'coach_reschedule_alert_box.dart';

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final bool isActionInProgress;
  final VoidCallback? onAccept, onReject, onReschedule;
  final VoidCallback? onAcceptReschedule, onDeclineReschedule;
  final VoidCallback? onComplete;

  const BookingCard({
    super.key,
    required this.booking,
    this.isActionInProgress = false,
    this.onAccept,
    this.onReject,
    this.onReschedule,
    this.onAcceptReschedule,
    this.onDeclineReschedule,
    this.onComplete,
  });

  void _navigateToDetails(BuildContext context) {
    context.push(
      AppRoutes.bookingDetails,
      extra: BookingDetailsArgs(booking: booking, isCoach: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // A request the coach never answered before its time is just history.
    final isExpired = BookingTransitions.isExpired(booking, DateTime.now());
    final isPending = booking.status == 'pending' && !isExpired;
    final isHistory =
        isExpired ||
        booking.status == 'completed' ||
        booking.status == 'rejected' ||
        booking.status == 'cancelled';
    final dateFormatted = CoachBookingDateHelper.formatHumanDate(
      context,
      booking.date,
    );

    return Opacity(
      opacity: isHistory ? 0.90 : 1.0,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
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
                  BookingCardHeader(booking: booking, isDark: isDark),
                  SizedBox(height: 10.h),
                  BookingCardInfo(
                    dateFormatted: dateFormatted,
                    startTime: booking.startTime,
                    endTime: booking.endTime,
                    isDark: isDark,
                    isMonthly: booking.isMonthly,
                    sessionsCount: booking.sessions.length,
                    location: booking.trainingLocation,
                    isOnline: booking.isOnline,
                  ),
                  if (booking.notes.isNotEmpty ||
                      (booking.status == 'rejected' &&
                          booking.rejectionReason?.isNotEmpty == true)) ...[
                    SizedBox(height: 8.h),
                    BookingCardNotes(
                      notes: booking.notes,
                      rejectionReason: booking.rejectionReason,
                      isDark: isDark,
                    ),
                  ],
                  if (booking.isReschedulePending &&
                      !booking.isMonthly &&
                      !isExpired) ...[
                    SizedBox(height: 10.h),
                    if (booking.rescheduledBy == AppConstants.roleTrainee &&
                        onAcceptReschedule != null &&
                        onDeclineReschedule != null)
                      CoachRescheduleAlertBox(
                        booking: booking,
                        isDark: isDark,
                        isActionInProgress: isActionInProgress,
                        onAccept: onAcceptReschedule!,
                        onDecline: onDeclineReschedule!,
                      )
                    else
                      BookingCardRescheduleInfo(
                        booking: booking,
                        isDark: isDark,
                      ),
                  ],
                  if (booking.isMonthly)
                    BookingCardCompactProgress(
                      booking: booking,
                      isDark: isDark,
                    ),
                  if (isPending) ...[
                    SizedBox(height: 12.h),
                    BookingCardActions(
                      isActionInProgress: isActionInProgress,
                      onAccept: onAccept,
                      onReject: onReject,
                      onReschedule: onReschedule,
                    ),
                  ],
                  if (booking.status == 'confirmed' &&
                      !booking.isMonthly &&
                      onComplete != null &&
                      BookingTransitions.canCompleteBooking(
                        booking,
                        DateTime.now(),
                      )) ...[
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isActionInProgress ? null : onComplete,
                        icon: Icon(Icons.check_rounded, size: 14.r),
                        label: Text(
                          s.markAsCompleted,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.success,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.smAll,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  ] else if (booking.status == 'confirmed' &&
                      !booking.isMonthly &&
                      onReschedule != null &&
                      !BookingTransitions.canCompleteBooking(
                        booking,
                        DateTime.now(),
                      )) ...[
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
