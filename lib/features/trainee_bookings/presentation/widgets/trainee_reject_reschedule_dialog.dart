import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

class TraineeRejectRescheduleDialog extends StatefulWidget {
  final ValueChanged<String?> onConfirm;

  const TraineeRejectRescheduleDialog({super.key, required this.onConfirm});

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<String?> onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => TraineeRejectRescheduleDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<TraineeRejectRescheduleDialog> createState() =>
      _TraineeRejectRescheduleDialogState();
}

class _TraineeRejectRescheduleDialogState
    extends State<TraineeRejectRescheduleDialog> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTxt =
        isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final secTxt =
        isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;

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
                color: primaryTxt,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.declineConfirmMessage,
              style: TextStyle(fontSize: 13.sp, color: secTxt),
            ),
            SizedBox(height: 12.h),
            Text(
              s.declineReasonLabel,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: primaryTxt,
              ),
            ),
            SizedBox(height: 6.h),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: s.declineReasonHint,
                hintStyle: TextStyle(fontSize: 11.sp, color: secTxt),
                border: OutlineInputBorder(borderRadius: AppRadius.smAll),
                contentPadding: EdgeInsets.all(10.r),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            MaterialLocalizations.of(context).cancelButtonLabel,
            style: TextStyle(fontSize: 13.sp, color: secTxt),
          ),
        ),
        FilledButton(
          onPressed: () {
            final reason = _reasonController.text.trim();
            Navigator.pop(context);
            widget.onConfirm(reason.isEmpty ? null : reason);
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
