import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'booking_request_state.dart';
import 'booking_slot_calculator.dart';

class BookingBuilderHelper {
  
  static BookingModel buildFromState({
    required BookingRequestState state,
    required String traineeUid,
    String? traineeName,
    String? traineePhotoUrl,
  }) {
    final coach = state.coach!;
    final isSession = state.isSession;

    String dateStr;
    String slot;
    String endTime;
    List<BookingSessionModel> sessions;

    if (isSession) {
      dateStr = formatDate(state.selectedDate!);
      slot = state.selectedSlot ?? 'Flexible';
      endTime = BookingSlotCalculator.computeEndTime(
        slot,
        coach.sessionDurationMinutes,
      );
      sessions = [
        BookingSessionModel(
          id: 's_1',
          date: dateStr,
          startTime: slot,
          endTime: endTime,
        ),
      ];
    } else {
      sessions = List<BookingSessionModel>.from(state.selectedMonthlySessions)
        ..sort((a, b) => a.date.compareTo(b.date));
      dateStr = sessions.isNotEmpty
          ? sessions.first.date
          : formatDate(state.selectedDate!);
      slot = sessions.isNotEmpty ? sessions.first.startTime : 'Flexible';
      endTime = sessions.isNotEmpty ? sessions.first.endTime : 'Flexible';
    }

    return BookingModel(
      id: '',
      coachUid: coach.uid,
      coachName: coach.name,
      coachPhotoUrl: coach.photoUrl,
      traineeUid: traineeUid,
      traineeName: traineeName?.isNotEmpty == true ? traineeName! : 'Trainee',
      traineePhotoUrl: traineePhotoUrl ?? '',
      sport: state.selectedSport!,
      bookingType: state.bookingType,
      date: dateStr,
      startTime: slot,
      endTime: endTime,
      price: state.totalPrice,
      currency: 'USD',
      durationMonths: isSession ? 1 : state.durationMonths,
      sessions: sessions,
      notes: state.notes,
      status: 'pending',
    );
  }

  static String formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
