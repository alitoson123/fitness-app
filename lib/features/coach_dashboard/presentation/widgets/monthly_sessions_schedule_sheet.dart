import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'monthly_session_tile.dart';
import 'monthly_sessions_schedule_header.dart';

class MonthlySessionsScheduleSheet extends StatelessWidget {
  final BookingModel booking;
  final bool isCoach, isActionInProgress;
  final void Function(String sessionId)? onMarkCompleted;
  final void Function(String sessionId)? onReschedule;
  final void Function(String sessionId)? onAcceptReschedule;
  final void Function(String sessionId)? onDeclineReschedule;

  const MonthlySessionsScheduleSheet({
    super.key,
    required this.booking,
    required this.isCoach,
    this.isActionInProgress = false,
    this.onMarkCompleted,
    this.onReschedule,
    this.onAcceptReschedule,
    this.onDeclineReschedule,
  });

  static Future<void> show({
    required BuildContext context,
    required BookingModel booking,
    required bool isCoach,
    bool isActionInProgress = false,
    void Function(String sessionId)? onMarkCompleted,
    void Function(String sessionId)? onReschedule,
    void Function(String sessionId)? onAcceptReschedule,
    void Function(String sessionId)? onDeclineReschedule,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => MonthlySessionsScheduleSheet(
          booking: booking,
          isCoach: isCoach,
          isActionInProgress: isActionInProgress,
          onMarkCompleted: onMarkCompleted,
          onReschedule: onReschedule,
          onAcceptReschedule: onAcceptReschedule,
          onDeclineReschedule: onDeclineReschedule,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sessions = booking.sessions;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 10.h),
          MonthlySessionsScheduleHeader(booking: booking, isCoach: isCoach),
          SizedBox(height: 12.h),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return MonthlySessionTile(
                  session: session,
                  sessionIndex: index + 1,
                  sport: booking.sport,
                  location: booking.trainingLocation,
                  isOnline: booking.isOnline,
                  isCoach: isCoach,
                  isActionInProgress: isActionInProgress,
                  onMarkCompleted: onMarkCompleted != null
                      ? () => onMarkCompleted!(session.id)
                      : null,
                  onReschedule: onReschedule != null
                      ? () => onReschedule!(session.id)
                      : null,
                  onAcceptReschedule: onAcceptReschedule != null
                      ? () => onAcceptReschedule!(session.id)
                      : null,
                  onDeclineReschedule: onDeclineReschedule != null
                      ? () => onDeclineReschedule!(session.id)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
