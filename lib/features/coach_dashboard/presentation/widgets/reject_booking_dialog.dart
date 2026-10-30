import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import 'reject_reason_selector.dart';

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
  String _selectedReasonKey = 'schedule_conflict';

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String _formatFinalReason(List<(String, String)> reasons) {
    final notes = _reasonController.text.trim();
    final option = reasons.firstWhere((r) => r.$1 == _selectedReasonKey).$2;
    if (_selectedReasonKey == 'other') return notes;
    return notes.isNotEmpty ? '$option - $notes' : option;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reasons = [
      ('schedule_conflict', s.rejectReasonScheduleConflict),
      ('fully_booked', s.rejectReasonFullyBooked),
      ('outside_hours', s.rejectReasonOutsideHours),
      ('other', s.rejectReasonOther),
    ];
    final isOther = _selectedReasonKey == 'other';
    final canSubmit = !isOther || _reasonController.text.trim().isNotEmpty;

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
            SizedBox(height: 12.h),
            Text(
              s.selectRejectionReasonLabel,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            RejectReasonSelector(
              reasons: reasons,
              selectedKey: _selectedReasonKey,
              onSelect: (key) => setState(() => _selectedReasonKey = key),
            ),
            SizedBox(height: 6.h),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              style: TextStyle(fontSize: 12.sp),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: isOther
                    ? s.rejectionNotesRequiredHint
                    : s.rejectionNotesHint,
                hintStyle: TextStyle(fontSize: 12.sp),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                contentPadding: EdgeInsets.all(10.r),
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
          style: FilledButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: canSubmit
              ? () {
                  final reason = _formatFinalReason(reasons);
                  Navigator.of(context).pop();
                  widget.onConfirm(reason.isEmpty ? null : reason);
                }
              : null,
          child: Text(s.confirmDecline),
        ),
      ],
    );
  }
}
