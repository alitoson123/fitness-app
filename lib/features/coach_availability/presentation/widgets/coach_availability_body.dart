import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../generated/l10n.dart';
import '../view_model/coach_availability_cubit/coach_availability_cubit.dart';
import '../view_model/coach_availability_cubit/coach_availability_states.dart';
import 'availability_header_card.dart';
import 'day_selector_row.dart';
import 'save_availability_button.dart';
import 'slot_duration_picker.dart';
import 'time_slot_configurator.dart';

class CoachAvailabilityBody extends StatelessWidget {
  final CoachAvailabilityLoaded state;
  final CoachAvailabilityCubit cubit;
  final String coachUid;

  const CoachAvailabilityBody({
    super.key,
    required this.state,
    required this.cubit,
    required this.coachUid,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvailabilityHeaderCard(
            activeDaysCount: state.activeDaysCount,
            sessionDurationMinutes: state.sessionDurationMinutes,
          ),
          SizedBox(height: 20.h),
          Text(
            S.of(context).workingDays,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 10.h),
          DaySelectorRow(
            schedule: state.schedule,
            selectedDay: state.selectedDay,
            onSelectDay: cubit.selectDay,
          ),
          SizedBox(height: 16.h),
          TimeSlotConfigurator(
            availability: state.currentDayAvailability,
            sessionDurationMinutes: state.sessionDurationMinutes,
            onToggleAvailable: (val) =>
                cubit.setDayAvailable(state.selectedDay, val),
            onFromTimeChanged: (time) =>
                cubit.updateDayTime(state.selectedDay, fromTime: time),
            onToTimeChanged: (time) =>
                cubit.updateDayTime(state.selectedDay, toTime: time),
            onApplyToAllDays: cubit.applyCurrentTimesToAllActiveDays,
          ),
          SizedBox(height: 24.h),
          SlotDurationPicker(
            selectedDurationMinutes: state.sessionDurationMinutes,
            onDurationChanged: cubit.setSessionDuration,
          ),
          SizedBox(height: 32.h),
          SaveAvailabilityButton(
            isLoading: state.isSaving,
            onSave: () => cubit.saveAvailability(coachUid),
          ),
          SizedBox(height: 48.h),
        ],
      ),
    );
  }
}
