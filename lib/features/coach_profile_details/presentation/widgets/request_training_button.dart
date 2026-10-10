import 'package:fitness_app/core/navigator/app_routes.dart';
import 'package:fitness_app/core/theme/app_colors.dart';
import 'package:fitness_app/core/theme/app_radius.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RequestTrainingButton extends StatelessWidget {
  final CoachProfileModel coach;

  const RequestTrainingButton({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = isDark ? AppColors.flameRed : AppColors.primary;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final border = isDark ? AppColors.darkBorder : AppColors.border;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border(top: BorderSide(color: border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).pricePerSession,
                  style: TextStyle(fontSize: 11.sp, color: textSecondary),
                ),
                Text(
                  '${coach.sessionPrice.toStringAsFixed(0)} ${coach.currency}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: primary,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _handleRequest(context),
                icon: const Icon(Icons.calendar_month_rounded, color: Colors.white),
                label: Text(
                  S.of(context).requestTraining,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleRequest(BuildContext context) {
    context.push(AppRoutes.bookingRequest, extra: coach);
  }
}
