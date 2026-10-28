import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class CoachWelcomeHeader extends StatelessWidget {
  final String? coachName;
  final String? phoneNumber;

  const CoachWelcomeHeader({
    super.key,
    this.coachName,
    this.phoneNumber,
  });

  String _getGreeting(BuildContext context, String name) {
    final s = S.of(context);
    final hour = DateTime.now().hour;
    if (hour < 12) return s.greetingMorning(name);
    if (hour < 17) return s.greetingAfternoon(name);
    return s.greetingEvening(name);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = (coachName != null && coachName!.trim().isNotEmpty)
        ? coachName!.trim()
        : (phoneNumber != null && phoneNumber!.trim().isNotEmpty
            ? phoneNumber!.trim()
            : s.iAmCoach);
    final greeting = _getGreeting(context, displayName);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: AppRadius.lgAll,
        border: Border.all(
          color: isDark
              ? AppColors.flameRed.withValues(alpha: 0.28)
              : AppColors.border,
          width: 1.2,
        ),
        gradient: isDark
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.darkSurface,
                  AppColors.flameRed.withValues(alpha: 0.06),
                ],
              )
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            backgroundColor: AppColors.flameRed.withValues(alpha: 0.15),
            child: Text(
              displayName.isNotEmpty ? displayName[0].toUpperCase() : 'C',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.flameRed,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        greeting,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.flameRed.withValues(alpha: 0.12),
                        borderRadius: AppRadius.fullAll,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 11.r,
                            color: AppColors.flameRed,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            s.verifiedCoach,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.flameRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  s.coachReadySubtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
