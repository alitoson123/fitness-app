import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_actions/booking_transitions.dart';
import '../../../coach_dashboard/presentation/widgets/booking_card_actions.dart';
import '../../../coach_dashboard/presentation/widgets/reject_booking_dialog.dart';
import '../../../coach_dashboard/presentation/widgets/reschedule_booking_sheet.dart';
import '../../../trainee_bookings/presentation/widgets/trainee_cancel_booking_dialog.dart';
import '../view_model/booking_details_cubit/booking_details_cubit.dart';

class BookingDetailsBottomActions extends StatelessWidget {
  final BookingModel booking;
  final bool isCoach;
  final bool isActionInProgress;

  const BookingDetailsBottomActions({
    super.key,
    required this.booking,
    required this.isCoach,
    required this.isActionInProgress,
  });

  void _onReject(BuildContext context) {
    final cubit = context.read<BookingDetailsCubit>();
    RejectBookingDialog.show(
      context: context,
      booking: booking,
      onConfirm: (reason) => cubit.rejectBooking(reason: reason),
    );
  }

  void _onReschedule(BuildContext context) {
    final cubit = context.read<BookingDetailsCubit>();
    RescheduleBookingSheet.show(
      context: context,
      booking: booking,
      onConfirm: (date, start, end, reason, {sessionId}) =>
          cubit.requestReschedule(
            proposedDate: date,
            proposedStartTime: start,
            proposedEndTime: end,
            reason: reason,
          ),
    );
  }

  void _onCancel(BuildContext context) {
    final cubit = context.read<BookingDetailsCubit>();
    TraineeCancelBookingDialog.show(
      context: context,
      onConfirm: (reason) => cubit.cancelBooking(reason: reason),
    );
  }

  Widget _buildCancelButton(BuildContext context, S s) => SizedBox(
    width: double.infinity,
    child: TextButton.icon(
      onPressed: isActionInProgress ? null : () => _onCancel(context),
      icon: Icon(Icons.close_rounded, size: 16.r),
      label: Text(s.cancelBookingAction, style: TextStyle(fontSize: 13.sp)),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.error,
        padding: EdgeInsets.symmetric(vertical: 8.h),
      ),
    ),
  );

  Widget _buildReschedulePendingActions(BuildContext context, S s) {
    final cubit = context.read<BookingDetailsCubit>();
    final canRespond =
        (isCoach && booking.rescheduledBy == AppConstants.roleTrainee) ||
        (!isCoach && booking.rescheduledBy == AppConstants.roleCoach);

    if (canRespond) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isActionInProgress
                  ? null
                  : () => cubit.declineReschedule(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
              ),
              child: Text(
                s.declineReschedule,
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: FilledButton(
              onPressed: isActionInProgress
                  ? null
                  : () => cubit.acceptReschedule(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
              ),
              child: Text(s.acceptNewTime, style: TextStyle(fontSize: 12.sp)),
            ),
          ),
        ],
      );
    }

    final amber = const Color(0xFFF59E0B);
    final badgeLabel = isCoach
        ? s.reschedulePendingBadge
        : s.reschedulePendingCoachBadge;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: amber.withValues(alpha: 0.1),
        borderRadius: AppRadius.smAll,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule_rounded, size: 16.r, color: amber),
          SizedBox(width: 8.w),
          Text(
            badgeLabel,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: amber,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<BookingDetailsCubit>();

    Widget? child;
    if (BookingTransitions.isExpired(booking, DateTime.now())) {
      // Nobody can act on it any more; say why.
      child = Row(
        children: [
          Icon(
            Icons.timer_off_rounded,
            size: 16.r,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.textSecondary,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              s.requestExpiredMessage,
              style: TextStyle(
                fontSize: 12.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      );
    } else if (booking.status == 'pending' && isCoach) {
      child = BookingCardActions(
        isActionInProgress: isActionInProgress,
        onAccept: () => cubit.acceptBooking(),
        onReject: () => _onReject(context),
        onReschedule: () => _onReschedule(context),
      );
    } else if (booking.status == 'reschedule_pending' && !booking.isMonthly) {
      child = _buildReschedulePendingActions(context, s);
    } else if (booking.status == 'confirmed' &&
        !booking.isMonthly &&
        BookingTransitions.canCompleteBooking(booking, DateTime.now())) {
      // The session time has come: the coach records it; rescheduling a
      // session that already started makes no sense, so it's not offered.
      child = isCoach
          ? SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isActionInProgress
                    ? null
                    : () => cubit.completeBooking(),
                icon: Icon(Icons.check_rounded, size: 16.r),
                label: Text(
                  s.markAsCompleted,
                  style: TextStyle(fontSize: 13.sp),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            )
          : null;
    } else if (booking.status == 'confirmed' && !booking.isMonthly) {
      child = SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: isActionInProgress ? null : () => _onReschedule(context),
          icon: Icon(Icons.schedule_rounded, size: 16.r),
          label: Text(s.rescheduleSession, style: TextStyle(fontSize: 13.sp)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
            padding: EdgeInsets.symmetric(vertical: 10.h),
          ),
        ),
      );
    }

    // Trainee: cancel (or withdraw a request) until the booking starts.
    if (!isCoach && BookingTransitions.canCancel(booking, DateTime.now())) {
      final cancel = _buildCancelButton(context, s);
      child = child == null
          ? cancel
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                child,
                SizedBox(height: 4.h),
                cancel,
              ],
            );
    }

    if (child == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}
