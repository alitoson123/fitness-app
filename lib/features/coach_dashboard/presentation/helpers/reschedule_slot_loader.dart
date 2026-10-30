import '../../../../core/locator_service/service_locator.dart';
import '../../../booking_request/data/repos/booking_request_repo.dart';
import '../../../booking_request/presentation/view_model/booking_request_cubit/booking_slot_calculator.dart';
import '../../../coach_availability/data/data_source/coach_availability_remote_data_source.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

abstract class RescheduleSlotLoader {
  static List<DateTime> generateNext14Days() {
    final now = DateTime.now();
    return List.generate(
      14,
      (i) => DateTime(now.year, now.month, now.day + 1 + i),
    );
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static Future<CoachProfileModel?> loadCoach(String coachUid) {
    return getIt<CoachAvailabilityRemoteDataSource>().getCoachProfile(coachUid);
  }

  static DateTime findInitialDate(
    List<DateTime> dates,
    CoachProfileModel? coach,
  ) {
    return dates.firstWhere(
      (d) =>
          coach == null || BookingSlotCalculator.isCoachWorkingOnDay(coach, d),
      orElse: () => dates.first,
    );
  }

  static Future<List<String>> loadSlots({
    required String coachUid,
    required DateTime date,
    required CoachProfileModel? coach,
  }) async {
    final repo = getIt<BookingRequestRepo>();
    final dateStr = formatDate(date);
    final res = await repo.getBookedSlots(coachUid: coachUid, date: dateStr);
    final booked = res.getOrElse(() => []);
    final coachModel = coach ?? CoachProfileModel(uid: coachUid);
    return BookingSlotCalculator.generateDaySlots(
      coach: coachModel,
      date: date,
      bookedSlots: booked,
    );
  }
}
