import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'booking_builder_helper.dart';
import 'booking_slot_calculator.dart';

class MonthlySessionsManager {
  static List<BookingSessionModel> toggleSession({
    required List<BookingSessionModel> currentSessions,
    required DateTime date,
    required String timeSlot,
    required int sessionDurationMinutes,
    required int maxSessions,
  }) {
    final dateStr = BookingBuilderHelper.formatDate(date);
    final existingIndex = currentSessions.indexWhere((s) => s.date == dateStr);
    final list = List<BookingSessionModel>.from(currentSessions);

    if (existingIndex != -1) {
      if (list[existingIndex].startTime == timeSlot) {
        list.removeAt(existingIndex);
      } else {
        final endTime = BookingSlotCalculator.computeEndTime(
          timeSlot,
          sessionDurationMinutes,
        );
        list[existingIndex] = list[existingIndex].copyWith(
          startTime: timeSlot,
          endTime: endTime,
        );
      }
    } else {
      if (list.length >= maxSessions) return list;
      final endTime = BookingSlotCalculator.computeEndTime(
        timeSlot,
        sessionDurationMinutes,
      );
      list.add(
        BookingSessionModel(
          id: 's_${dateStr}_$timeSlot',
          date: dateStr,
          startTime: timeSlot,
          endTime: endTime,
        ),
      );
    }

    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  static List<BookingSessionModel> removeSession(
    List<BookingSessionModel> currentSessions,
    String sessionId,
  ) {
    return currentSessions.where((s) => s.id != sessionId).toList();
  }
}

