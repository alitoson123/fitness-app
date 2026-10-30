import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../generated/l10n.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/booking_request_cubit/booking_request_cubit.dart';
import '../view_model/booking_request_cubit/booking_request_state.dart';
import 'booking_coach_summary_card.dart';
import 'booking_date_strip.dart';
import 'booking_notes_field.dart';
import 'booking_sport_chips.dart';
import 'booking_summary_card.dart';
import 'booking_time_slots_grid.dart';
import 'booking_type_selector.dart';
import 'weekly_frequency_selector.dart';

class BookingRequestBody extends StatelessWidget {
  final CoachProfileModel coach;
  final BookingRequestState state;
  final BookingRequestCubit cubit;

  const BookingRequestBody({
    super.key,
    required this.coach,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingCoachSummaryCard(coach: coach),
          SizedBox(height: 18.h),
          BookingTypeSelector(
            coach: coach,
            selectedType: state.bookingType,
            onTypeSelected: cubit.selectBookingType,
          ),
          SizedBox(height: 18.h),
          if (coach.sports.isNotEmpty) ...[
            BookingSportChips(
              sports: coach.sports,
              selectedSport: state.selectedSport,
              onSelectSport: cubit.selectSport,
            ),
            SizedBox(height: 18.h),
          ],
          BookingDateStrip(
            dates: state.availableDates,
            selectedDate: state.selectedDate,
            coach: coach,
            title: state.isMonthly ? s.selectPackageStartDate : s.selectTrainingDate,
            onSelectDate: cubit.loadSlotsForDate,
          ),
          SizedBox(height: 18.h),
          if (state.isSession) ...[
            BookingTimeSlotsGrid(
              slots: state.availableSlots,
              selectedSlot: state.selectedSlot,
              isLoading: state.status == BookingRequestStatus.loadingSlots,
              onSelectSlot: cubit.selectSlot,
            ),
            SizedBox(height: 18.h),
          ] else ...[
            WeeklyFrequencySelector(
              selectedFrequency: state.weeklyFrequency,
              onFrequencySelected: cubit.selectWeeklyFrequency,
            ),
            SizedBox(height: 18.h),
          ],
          BookingSummaryCard(
            coach: coach,
            bookingType: state.bookingType,
            sport: state.selectedSport,
            date: state.selectedDate,
            slot: state.selectedSlot,
            weeklyFrequency: state.weeklyFrequency,
            durationMonths: state.durationMonths,
          ),
          SizedBox(height: 18.h),
          BookingNotesField(onChanged: cubit.updateNotes),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
