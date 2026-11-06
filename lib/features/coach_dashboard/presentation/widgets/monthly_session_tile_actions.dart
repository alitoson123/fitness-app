import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_session_model.dart';

class MonthlySessionTileActions extends StatelessWidget {
  final BookingSessionModel session;
  final bool isCoach, isActionInProgress;
  final VoidCallback? onMarkCompleted, onReschedule;
  final VoidCallback? onAcceptReschedule, onDeclineReschedule;

  const MonthlySessionTileActions({
    super.key,
    required this.session,
    required this.isCoach,
    this.isActionInProgress = false,
    this.onMarkCompleted,
    this.onReschedule,
    this.onAcceptReschedule,
    this.onDeclineReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final canRespondToReschedule = session.isReschedulePending &&
        ((isCoach && session.rescheduledBy == AppConstants.roleTrainee) ||
            (!isCoach && session.rescheduledBy == AppConstants.roleCoach));

    if (canRespondToReschedule) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: isActionInProgress ? null : onDeclineReschedule,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: EdgeInsets.symmetric(vertical: 4.h),
              ),
              child: Text(s.declineReschedule, style: TextStyle(fontSize: 10.sp)),
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: FilledButton(
              onPressed: isActionInProgress ? null : onAcceptReschedule,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(vertical: 4.h),
              ),
              child: Text(s.acceptNewTime, style: TextStyle(fontSize: 10.sp)),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        if (isCoach && !session.isCompleted && onMarkCompleted != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isActionInProgress ? null : onMarkCompleted,
              icon: Icon(Icons.check_rounded, size: 12.r),
              label: Text(s.markAsCompleted, style: TextStyle(fontSize: 10.sp)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.success,
                side: const BorderSide(color: AppColors.success),
                padding: EdgeInsets.symmetric(vertical: 4.h),
              ),
            ),
          ),
        if (isCoach && !session.isCompleted && onMarkCompleted != null && session.canReschedule)
          SizedBox(width: 6.w),
        if (session.canReschedule && onReschedule != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isActionInProgress ? null : onReschedule,
              icon: Icon(Icons.edit_calendar_rounded, size: 12.r),
              label: Text(s.rescheduleThisSession, style: TextStyle(fontSize: 10.sp)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                padding: EdgeInsets.symmetric(vertical: 4.h),
              ),
            ),
          ),
      ],
    );
  }
}

