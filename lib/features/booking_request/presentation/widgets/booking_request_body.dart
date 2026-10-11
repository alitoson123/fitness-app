import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';
import '../view_model/booking_request_cubit/booking_request_cubit.dart';
import '../view_model/booking_request_cubit/booking_request_state.dart';
import 'booking_coach_summary_card.dart';
import 'booking_date_strip.dart';
import 'booking_notes_field.dart';
import 'booking_sport_chips.dart';
import 'booking_summary_card.dart';
import 'booking_time_slots_grid.dart';

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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BookingCoachSummaryCard(coach: coach),
          SizedBox(height: 20.h),
          if (coach.sports.isNotEmpty) ...[
            BookingSportChips(
              sports: coach.sports,
              selectedSport: state.selectedSport,
              onSelectSport: cubit.selectSport,
            ),
            SizedBox(height: 20.h),
          ],
          BookingDateStrip(
            dates: state.availableDates,
            selectedDate: state.selectedDate,
            coach: coach,
            onSelectDate: cubit.loadSlotsForDate,
          ),
          SizedBox(height: 20.h),
          BookingTimeSlotsGrid(
            slots: state.availableSlots,
            selectedSlot: state.selectedSlot,
            isLoading: state.status == BookingRequestStatus.loadingSlots,
            onSelectSlot: cubit.selectSlot,
          ),
          SizedBox(height: 20.h),
          BookingSummaryCard(
            coach: coach,
            sport: state.selectedSport,
            date: state.selectedDate,
            slot: state.selectedSlot,
          ),
          SizedBox(height: 20.h),
          BookingNotesField(onChanged: cubit.updateNotes),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
