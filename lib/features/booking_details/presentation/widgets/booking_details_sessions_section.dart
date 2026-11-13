import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_actions/booking_transitions.dart';
import '../../../coach_dashboard/presentation/widgets/monthly_session_tile.dart';
import '../../../coach_dashboard/presentation/widgets/reschedule_booking_sheet.dart';
import '../view_model/booking_details_cubit/booking_details_cubit.dart';

class BookingDetailsSessionsSection extends StatelessWidget {
  final BookingModel booking;
  final bool isCoach;
  final bool isActionInProgress;
  final String? actionSessionId;

  const BookingDetailsSessionsSection({
    super.key,
    required this.booking,
    required this.isCoach,
    required this.isActionInProgress,
    this.actionSessionId,
  });

  void _onRescheduleSession(BuildContext context, String targetSessionId) {
    final cubit = context.read<BookingDetailsCubit>();
    RescheduleBookingSheet.show(
      context: context,
      booking: booking,
      initialSessionId: targetSessionId,
      onConfirm: (date, start, end, reason, {sessionId}) async {
        await cubit.requestMonthlySessionReschedule(
          sessionId: sessionId ?? targetSessionId,
          proposedDate: date,
          proposedStartTime: start,
          proposedEndTime: end,
          reason: reason,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!booking.isMonthly) return const SizedBox.shrink();

    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.read<BookingDetailsCubit>();
    final now = DateTime.now();
    // No session actions on cancelled / rejected / finished packages.
    final canAct = BookingTransitions.canActOnSessions(booking);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.sessionsSchedule,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(
              s.monthlyProgressCompleted(
                booking.completedSessionsCount,
                booking.sessionsCount,
              ),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: booking.progressRatio,
            minHeight: 5.h,
            backgroundColor: isDark ? AppColors.darkBorder : Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        SizedBox(height: 12.h),
        ...booking.sessions.asMap().entries.map((entry) {
          final index = entry.key;
          final session = entry.value;
          final isTileBusy =
              isActionInProgress && actionSessionId == session.id;

          return MonthlySessionTile(
            session: session,
            sessionIndex: index + 1,
            sport: booking.sport,
            location: booking.trainingLocation,
            isOnline: booking.isOnline,
            isCoach: isCoach,
            isActionInProgress: isTileBusy,
            onMarkCompleted: isCoach &&
                    BookingTransitions.canCompleteSession(booking, session, now)
                ? () => cubit.markSessionCompleted(session.id)
                : null,
            onReschedule: canAct && !session.isReschedulePending
                ? () => _onRescheduleSession(context, session.id)
                : null,
            onAcceptReschedule: canAct
                ? () => cubit.acceptMonthlySessionReschedule(session.id)
                : null,
            onDeclineReschedule: canAct
                ? () => cubit.declineMonthlySessionReschedule(session.id)
                : null,
          );
        }),
      ],
    );
  }
}
