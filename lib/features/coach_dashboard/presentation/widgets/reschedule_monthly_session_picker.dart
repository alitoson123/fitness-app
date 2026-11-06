import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_session_model.dart';

class RescheduleMonthlySessionPicker extends StatelessWidget {
  final List<BookingSessionModel> sessions;
  final String? selectedSessionId;
  final ValueChanged<String> onSelectSession;

  const RescheduleMonthlySessionPicker({
    super.key,
    required this.sessions,
    required this.selectedSessionId,
    required this.onSelectSession,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIdx = sessions.indexWhere((s) => s.id == selectedSessionId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              s.selectSessionToReschedule,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            if (selectedIdx != -1)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: AppRadius.fullAll,
                ),
                child: Text(
                  s.modifyingSession(selectedIdx + 1),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 64.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sessions.length,
            separatorBuilder: (_, _) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final session = sessions[index];
              final isSelected = session.id == selectedSessionId;
              final isCompleted = session.isCompleted;
              final canSelect = session.canReschedule;

              return InkWell(
                onTap: canSelect ? () => onSelectSession(session.id) : null,
                borderRadius: AppRadius.smAll,
                child: Opacity(
                  opacity: canSelect ? 1.0 : 0.5,
                  child: Container(
                    width: 130.w,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : (isDark ? AppColors.darkSurface : Colors.grey[50]),
                      borderRadius: AppRadius.smAll,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.darkBorder : AppColors.border),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              s.sessionIndex(index + 1),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary),
                              ),
                            ),
                            const Spacer(),
                            if (isCompleted)
                              Icon(Icons.check_circle_rounded,
                                  size: 13.r, color: AppColors.success)
                            else if (session.isReschedulePending)
                              Icon(Icons.schedule_rounded,
                                  size: 13.r, color: const Color(0xFFF59E0B)),
                          ],
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          '${session.date} • ${session.startTime}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

