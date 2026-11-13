import '../../../../core/locator_service/service_locator.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../booking_request/data/repos/booking_request_repo.dart';
import '../../../booking_request/presentation/view_model/booking_request_cubit/booking_slot_calculator.dart';
import '../../../coach_availability/data/data_source/coach_availability_remote_data_source.dart';
import '../../../coach_setup/data/models/coach_profile_model.dart';

abstract class RescheduleSlotLoader {
  /// The next 30 days, starting tomorrow.
  static List<DateTime> generateNext14Days() {
    final now = DateTime.now();
    return List.generate(
      30,
      (i) => DateTime(now.year, now.month, now.day + 1 + i),
    );
  }

  static String formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// The coach's profile (hours, session length), or null if it can't be
  /// loaded. Without it we can't know the coach's real hours, so the sheet
  /// shows Retry instead of guessing.
  static Future<CoachProfileModel?> loadCoach(String coachUid) async {
    try {
      return await getIt<CoachAvailabilityRemoteDataSource>().getCoachProfile(
        coachUid,
      );
    } catch (e, st) {
      LoggerService.error(
        'Failed to load coach for reschedule',
        tag: 'RescheduleSlotLoader',
        error: e,
        stackTrace: st,
      );
      return null;
    }
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

  /// Free start times on [date], or null when they couldn't be loaded.
  static Future<List<String>?> loadSlots({
    required CoachProfileModel coach,
    required DateTime date,
  }) async {
    final res = await getIt<BookingRequestRepo>().getBusyRanges(
      coachUid: coach.uid,
      date: formatDate(date),
      sessionDurationMinutes: coach.sessionDurationMinutes,
    );
    return res.fold(
      (_) => null,
      (busy) => BookingSlotCalculator.generateDaySlots(
        coach: coach,
        date: date,
        busyRanges: busy,
      ),
    );
  }
}
