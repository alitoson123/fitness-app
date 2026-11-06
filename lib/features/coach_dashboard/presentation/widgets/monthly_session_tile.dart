import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_session_model.dart';
import 'monthly_session_tile_actions.dart';

class MonthlySessionTile extends StatelessWidget {
  final BookingSessionModel session;
  final int sessionIndex;
  final String sport, location;
  final bool isOnline, isCoach, isActionInProgress;
  final VoidCallback? onMarkCompleted, onReschedule;
  final VoidCallback? onAcceptReschedule, onDeclineReschedule;

  const MonthlySessionTile({
    super.key,
    required this.session,
    required this.sessionIndex,
    required this.sport,
    required this.location,
    required this.isOnline,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.smAll,
        border: Border.all(
          color: session.isReschedulePending
              ? const Color(0xFFF59E0B)
              : (isDark ? AppColors.darkBorder : AppColors.border),
          width: session.isReschedulePending ? 1.4 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.fullAll,
                ),
                child: Text(
                  '#$sessionIndex',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  '${session.date} • ${session.startTime} - ${session.endTime}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  ),
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          if (location.isNotEmpty || isOnline)
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Row(
                children: [
                  Icon(isOnline ? Icons.laptop_chromebook_rounded : Icons.location_on_rounded, size: 11.r, color: textSecondary),
                  SizedBox(width: 4.w),
                  Text(isOnline ? s.onlineTrainingOption : location, style: TextStyle(fontSize: 10.sp, color: textSecondary)),
                ],
              ),
            ),
          if (session.isReschedulePending)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                '${s.proposedTimeLabel}: ${session.proposedDate} (${session.proposedStartTime} - ${session.proposedEndTime})'
                '${session.rescheduleReason != null ? " • ${session.rescheduleReason}" : ""}',
                style: TextStyle(fontSize: 10.sp, color: const Color(0xFFF59E0B), fontStyle: FontStyle.italic),
              ),
            ),
          SizedBox(height: 8.h),
          MonthlySessionTileActions(
            session: session,
            isCoach: isCoach,
            isActionInProgress: isActionInProgress,
            onMarkCompleted: onMarkCompleted,
            onReschedule: onReschedule,
            onAcceptReschedule: onAcceptReschedule,
            onDeclineReschedule: onDeclineReschedule,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final s = S.of(context);
    final (label, color, icon) = session.isCompleted
        ? (s.statusCompleted, AppColors.success, Icons.check_circle_rounded)
        : (session.isReschedulePending
            ? (s.statusReschedulePending, const Color(0xFFF59E0B), Icons.schedule_rounded)
            : (s.statusUpcoming, AppColors.primary, Icons.access_time_rounded));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadius.fullAll,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r, color: color),
          SizedBox(width: 3.w),
          Text(label, style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}
