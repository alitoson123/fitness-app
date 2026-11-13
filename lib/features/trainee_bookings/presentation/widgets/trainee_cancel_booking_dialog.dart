import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';

/// Asks the trainee to confirm a cancellation, with an optional reason
/// that the coach will see.
class TraineeCancelBookingDialog extends StatefulWidget {
  final ValueChanged<String?> onConfirm;

  const TraineeCancelBookingDialog({super.key, required this.onConfirm});

  static Future<void> show({
    required BuildContext context,
    required ValueChanged<String?> onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => TraineeCancelBookingDialog(onConfirm: onConfirm),
    );
  }

  @override
  State<TraineeCancelBookingDialog> createState() =>
      _TraineeCancelBookingDialogState();
}

class _TraineeCancelBookingDialogState
    extends State<TraineeCancelBookingDialog> {
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
          Icon(Icons.event_busy_rounded, color: AppColors.error, size: 22.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              s.cancelBookingTitle,
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
              s.cancelBookingMessage,
              style: TextStyle(fontSize: 13.sp, color: secTxt),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              maxLength: 300,
              style: TextStyle(fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: s.cancelBookingReasonHint,
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
            s.keepBooking,
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
            s.cancelBookingAction,
            style: TextStyle(fontSize: 13.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
