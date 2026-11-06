import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../generated/l10n.dart';
import '../../../booking_request/data/models/booking_model.dart';
import '../../../booking_request/presentation/view_model/booking_request_cubit/booking_slot_calculator.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../helpers/reschedule_slot_loader.dart';
import 'reschedule_form_content.dart';

typedef RescheduleConfirmCallback = Future<void> Function(
  String date,
  String startTime,
  String endTime,
  String reason, {
  String? sessionId,
});

class RescheduleBookingSheet extends StatefulWidget {
  final BookingModel booking;
  final String? initialSessionId;
  final RescheduleConfirmCallback onConfirm;

  const RescheduleBookingSheet({
    super.key,
    required this.booking,
    this.initialSessionId,
    required this.onConfirm,
  });

  static Future<void> show({
    required BuildContext context,
    required BookingModel booking,
    String? initialSessionId,
    required RescheduleConfirmCallback onConfirm,
  }) =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => RescheduleBookingSheet(booking: booking, initialSessionId: initialSessionId, onConfirm: onConfirm),
      );

  @override
  State<RescheduleBookingSheet> createState() => _RescheduleBookingSheetState();
}

class _RescheduleBookingSheetState extends State<RescheduleBookingSheet> {
  final _reasonController = TextEditingController();
  CoachProfileModel? _coach;
  DateTime? _selectedDate;
  String? _selectedSlot, _selectedSessionId, _reasonError;
  List<String> _availableSlots = [];
  bool _isLoadingSlots = false, _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.booking.isMonthly && widget.booking.sessions.isNotEmpty) {
      _selectedSessionId = widget.initialSessionId ??
          widget.booking.nextUpcomingSession?.id ??
          widget.booking.sessions.first.id;
    }
    _loadCoachAndInitialSlots();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadCoachAndInitialSlots() async {
    final coach = await RescheduleSlotLoader.loadCoach(widget.booking.coachUid);
    if (!mounted) return;
    setState(() => _coach = coach);
    _onDateSelected(RescheduleSlotLoader.findInitialDate(RescheduleSlotLoader.generateNext14Days(), coach));
  }

  Future<void> _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDate = date;
      _selectedSlot = null;
      _isLoadingSlots = true;
    });
    final slots = await RescheduleSlotLoader.loadSlots(coachUid: widget.booking.coachUid, date: date, coach: _coach);
    if (!mounted) return;
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
    if (widget.booking.isMonthly && _selectedSessionId == null) return;
    setState(() => _isSubmitting = true);
    final dateStr = RescheduleSlotLoader.formatDate(_selectedDate!);
    final endTime = BookingSlotCalculator.computeEndTime(_selectedSlot!, _coach?.sessionDurationMinutes ?? 60);
    await widget.onConfirm(dateStr, _selectedSlot!, endTime, reason, sessionId: widget.booking.isMonthly ? _selectedSessionId : null);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btm = MediaQuery.of(context).viewInsets.bottom + 20.h;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, btm),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: RescheduleFormContent(
        booking: widget.booking,
        dates: RescheduleSlotLoader.generateNext14Days(),
        coach: _coach,
        selectedDate: _selectedDate,
        selectedSlot: _selectedSlot,
        availableSlots: _availableSlots,
        isLoadingSlots: _isLoadingSlots,
        isSubmitting: _isSubmitting,
        reasonController: _reasonController,
        reasonError: _reasonError,
        selectedSessionId: _selectedSessionId,
        onSelectSession: (id) => setState(() => _selectedSessionId = id),
        onSelectDate: _onDateSelected,
        onSelectSlot: (slot) => setState(() => _selectedSlot = slot),
        onReasonChanged: (_) => setState(() => _reasonError = null),
        onSubmit: _submit,
      ),
    );
  }
}
