import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';

class RejectBookingDialog extends StatefulWidget {
  final BookingModel booking;
  final ValueChanged<String?> onConfirm;

  const RejectBookingDialog({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required BookingModel booking,
    required ValueChanged<String?> onConfirm,
  }) {
    return showDialog(
      context: context,
      builder: (_) => RejectBookingDialog(
        booking: booking,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<RejectBookingDialog> createState() => _RejectBookingDialogState();
}

class _RejectBookingDialogState extends State<RejectBookingDialog> {
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

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        s.rejectRequestDialogTitle,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s.rejectRequestDialogDesc(widget.booking.traineeName),
              style: TextStyle(
                fontSize: 13.sp,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 14.h),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              style: TextStyle(fontSize: 13.sp),
              decoration: InputDecoration(
                labelText: s.rejectionReasonOptional,
                hintText: s.rejectionReasonHint,
                hintStyle: TextStyle(fontSize: 12.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(s.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.error,
          ),
          onPressed: () {
            final reason = _reasonController.text.trim();
            Navigator.of(context).pop();
            widget.onConfirm(reason.isEmpty ? null : reason);
          },
          child: Text(s.confirmDecline),
        ),
      ],
    );
  }
}
