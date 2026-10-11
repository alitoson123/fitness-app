import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;

  const BookingStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);

    final (color, label, icon) = switch (status) {
      'confirmed' => (
          AppColors.success,
          s.statusConfirmed,
          Icons.check_circle_rounded,
        ),
      'completed' => (
          AppColors.secondary,
          s.statusCompleted,
          Icons.task_alt_rounded,
        ),
      'rejected' => (
          AppColors.error,
          s.statusDeclined,
          Icons.cancel_rounded,
        ),
      'cancelled' => (
          AppColors.darkTextTertiary,
          s.statusCancelled,
          Icons.block_rounded,
        ),
      _ => (
          AppColors.flameRed,
          s.statPending,
          Icons.hourglass_top_rounded,
        ),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.fullAll,
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.r, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
