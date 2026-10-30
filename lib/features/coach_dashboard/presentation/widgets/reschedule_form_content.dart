import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import 'reschedule_date_picker.dart';
import 'reschedule_reason_input.dart';
import 'reschedule_sheet_header.dart';
import 'reschedule_submit_button.dart';
import 'reschedule_time_slots.dart';

class RescheduleFormContent extends StatelessWidget {
  final List<DateTime> dates;
  final CoachProfileModel? coach;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final List<String> availableSlots;
  final bool isLoadingSlots;
  final bool isSubmitting;
  final TextEditingController reasonController;
  final String? reasonError;
  final ValueChanged<DateTime> onSelectDate;
  final ValueChanged<String> onSelectSlot;
  final ValueChanged<String> onReasonChanged;
  final VoidCallback onSubmit;

  const RescheduleFormContent({
    super.key,
    required this.dates,
    required this.coach,
    required this.selectedDate,
    required this.selectedSlot,
    required this.availableSlots,
    required this.isLoadingSlots,
    required this.isSubmitting,
    required this.reasonController,
    required this.reasonError,
    required this.onSelectDate,
    required this.onSelectSlot,
    required this.onReasonChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const RescheduleSheetHeader(),
          SizedBox(height: 14.h),
          if (coach != null)
            RescheduleDatePicker(
              dates: dates,
              selectedDate: selectedDate,
              coach: coach!,
              onSelectDate: onSelectDate,
            ),
          SizedBox(height: 14.h),
          RescheduleTimeSlots(
            availableSlots: availableSlots,
            selectedSlot: selectedSlot,
            isLoading: isLoadingSlots,
            onSelectSlot: onSelectSlot,
          ),
          SizedBox(height: 14.h),
          RescheduleReasonInput(
            controller: reasonController,
            errorText: reasonError,
            onChanged: onReasonChanged,
          ),
          SizedBox(height: 16.h),
          RescheduleSubmitButton(
            isSubmitting: isSubmitting,
            isEnabled: selectedSlot != null,
            onSubmit: onSubmit,
          ),
        ],
      ),
    );
  }
}

