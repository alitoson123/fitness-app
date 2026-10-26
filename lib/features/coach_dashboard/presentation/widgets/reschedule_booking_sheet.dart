import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/data/repos/booking_request_repo.dart';
import '../../../booking_request/presentation/view_model/booking_request_cubit/booking_slot_calculator.dart';
import '../../../coach_availability/data/data_source/coach_availability_remote_data_source.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'reschedule_date_picker.dart';
import 'reschedule_reason_input.dart';
import 'reschedule_time_slots.dart';

class RescheduleBookingSheet extends StatefulWidget {
  final BookingModel booking;
  final Future<void> Function(
    String proposedDate,
    String proposedStartTime,
    String proposedEndTime,
    String reason,
  ) onConfirm;

  const RescheduleBookingSheet({
    super.key,
    required this.booking,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required BookingModel booking,
    required Future<void> Function(
      String proposedDate,
      String proposedStartTime,
      String proposedEndTime,
      String reason,
    ) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RescheduleBookingSheet(
        booking: booking,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<RescheduleBookingSheet> createState() => _RescheduleBookingSheetState();
}

class _RescheduleBookingSheetState extends State<RescheduleBookingSheet> {
  final _reasonController = TextEditingController();
  CoachProfileModel? _coach;
  DateTime? _selectedDate;
  String? _selectedSlot;
  List<String> _availableSlots = [];
  bool _isLoadingSlots = false;
  bool _isSubmitting = false;
  String? _reasonError;

  @override
  void initState() {
    super.initState();
    _loadCoachAndInitialSlots();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadCoachAndInitialSlots() async {
    final ds = getIt<CoachAvailabilityRemoteDataSource>();
    final coach = await ds.getCoachProfile(widget.booking.coachUid);
    if (!mounted) return;
    setState(() => _coach = coach);

    final now = DateTime.now();
    final firstDate = DateTime(now.year, now.month, now.day + 1);
    _onDateSelected(firstDate);
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
      _isLoadingSlots = true;
    });

    final repo = getIt<BookingRequestRepo>();
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final res = await repo.getBookedSlots(
      coachUid: widget.booking.coachUid,
      date: dateStr,
    );

    if (!mounted) return;
    final booked = res.getOrElse(() => []);
    final coach = _coach ?? CoachProfileModel(uid: widget.booking.coachUid);
    final slots = BookingSlotCalculator.generateDaySlots(
      coach: coach,
      date: date,
      bookedSlots: booked,
    );

    setState(() {
      _availableSlots = slots;
      _isLoadingSlots = false;
    });
  }

  Future<void> _submit() async {
    final reason = _reasonController.text.trim();
    if (reason.length < 5) {
      setState(() => _reasonError = S.of(context).rescheduleReasonRequired);
      return;
    }
    if (_selectedDate == null || _selectedSlot == null) return;

    setState(() => _isSubmitting = true);
    final d = _selectedDate!;
    final dateStr =
        '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final duration = _coach?.sessionDurationMinutes ?? 60;
    final endTime = BookingSlotCalculator.computeEndTime(_selectedSlot!, duration);

    await widget.onConfirm(dateStr, _selectedSlot!, endTime, reason);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final dates = List.generate(14, (i) => DateTime(now.year, now.month, now.day + 1 + i));

    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        16.h,
        20.w,
        MediaQuery.of(context).viewInsets.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                  borderRadius: AppRadius.fullAll,
                ),
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              s.rescheduleSession,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 14.h),
            if (_coach != null)
              RescheduleDatePicker(
                dates: dates,
                selectedDate: _selectedDate,
                coach: _coach!,
                onSelectDate: _onDateSelected,
              ),
            SizedBox(height: 14.h),
            RescheduleTimeSlots(
              availableSlots: _availableSlots,
              selectedSlot: _selectedSlot,
              isLoading: _isLoadingSlots,
              onSelectSlot: (slot) => setState(() => _selectedSlot = slot),
            ),
            SizedBox(height: 14.h),
            RescheduleReasonInput(
              controller: _reasonController,
              errorText: _reasonError,
              onChanged: (_) => setState(() => _reasonError = null),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 46.h,
              child: FilledButton(
                onPressed: (_selectedSlot != null && !_isSubmitting) ? _submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.smAll),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(s.sendRescheduleRequest, style: TextStyle(fontSize: 14.sp)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
