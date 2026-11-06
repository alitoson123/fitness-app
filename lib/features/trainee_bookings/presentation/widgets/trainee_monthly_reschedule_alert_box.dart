import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constant/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/models/booking_session_model.dart';

class TraineeMonthlyRescheduleAlertBox extends StatelessWidget {
  final BookingModel booking;
  final bool isDark, isActionInProgress;
  final void Function(String sessionId) onAccept, onDecline;

  const TraineeMonthlyRescheduleAlertBox({
    super.key,
    required this.booking,
    required this.isDark,
    required this.isActionInProgress,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    final pendingSessions = booking.pendingRescheduleSessions;
    if (pendingSessions.isEmpty) return const SizedBox.shrink();

    return Column(
      children: pendingSessions.map((session) {
        final idx = booking.sessions.indexOf(session) + 1;
        return _buildSessionAlert(context, session, idx);
      }).toList(),
    );
  }

  Widget _buildSessionAlert(
    BuildContext context,
    BookingSessionModel session,
    int index,
  ) {
    final s = S.of(context);
    final textSecondary = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    const amberColor = Color(0xFFF59E0B);
    final isAwaitingCoach = session.rescheduledBy == AppConstants.roleTrainee;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: amberColor.withValues(alpha: 0.08),
        borderRadius: AppRadius.smAll,
        border: Border.all(color: amberColor.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_calendar_rounded, size: 16.r, color: amberColor),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  isAwaitingCoach
                      ? s.traineeProposedMonthlyReschedule(
                          index,
                          session.proposedDate ?? '',
                          '${session.proposedStartTime} - ${session.proposedEndTime}',
                        )
                      : s.coachProposedMonthlyReschedule(
                          index,
                          session.proposedDate ?? '',
                          '${session.proposedStartTime} - ${session.proposedEndTime}',
                        ),
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w700, color: amberColor),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            '${s.proposedTimeLabel}: ${session.proposedDate} (${session.proposedStartTime} - ${session.proposedEndTime})',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '${s.originalTimeLabel}: ${session.date} (${session.startTime} - ${session.endTime})',
            style: TextStyle(fontSize: 10.sp, color: textSecondary, decoration: TextDecoration.lineThrough),
          ),
          if (session.rescheduleReason?.isNotEmpty == true) ...[
            SizedBox(height: 4.h),
            Text(
              '${s.coachReasonLabel}: "${session.rescheduleReason}"',
              style: TextStyle(fontSize: 10.sp, fontStyle: FontStyle.italic, color: textSecondary),
            ),
          ],
          SizedBox(height: 10.h),
          if (isActionInProgress)
            const Center(child: SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)))
          else if (!isAwaitingCoach)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onDecline(session.id),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                    ),
                    child: Text(s.declineReschedule, style: TextStyle(fontSize: 11.sp)),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: FilledButton(
                    onPressed: () => onAccept(session.id),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                      padding: EdgeInsets.symmetric(vertical: 6.h),
                    ),
                    child: Text(s.acceptNewTime, style: TextStyle(fontSize: 11.sp)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
