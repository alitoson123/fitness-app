import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class TraineeRejectRescheduleDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const TraineeRejectRescheduleDialog({
    super.key,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => TraineeRejectRescheduleDialog(onConfirm: onConfirm),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              s.declineConfirmTitle,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        s.declineConfirmMessage,
        style: TextStyle(
          fontSize: 13.sp,
          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
            style: TextStyle(
              fontSize: 13.sp,
              color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
          ),
          child: Text(
            s.declineReschedule,
            style: TextStyle(fontSize: 13.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
