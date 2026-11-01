import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class CoachWelcomeHeader extends StatelessWidget {
  final String? coachName;
  final bool showSubtitle;

  const CoachWelcomeHeader({
    super.key,
    this.coachName,
    this.showSubtitle = false,
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
        : "Coach";
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
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: greeting,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Padding(
                          padding: EdgeInsetsDirectional.only(start: 6.w),
                          child: Icon(
                            Icons.verified_rounded,
                            size: 18.r,
                            color: AppColors.flameRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (showSubtitle) ...[
                  SizedBox(height: 4.h),
                  Text(
                    s.coachReadySubtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
