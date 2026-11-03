import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/features/trainee_profile/presentation/helpers/training_insights_calculator.dart';
import 'package:fitness_app/features/trainee_profile/presentation/helpers/training_period_navigator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrainingInsightsCalculator', () {
    test('returns empty set when no bookings exist', () {
      final days = TrainingInsightsCalculator.extractUniqueCompletedDays([]);
      expect(days, isEmpty);
    });

    test('ignores non-completed bookings and sessions', () {
      final bookings = [
        const BookingModel(
          id: '1',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-11-01',
          startTime: '10:00',
          endTime: '11:00',
          status: 'pending',
        ),
        const BookingModel(
          id: '2',
          coachUid: 'c2',
          traineeUid: 't1',
          sport: 'Boxing',
          date: '2026-11-02',
          startTime: '12:00',
          endTime: '13:00',
          status: 'confirmed',
        ),
      ];

      final days = TrainingInsightsCalculator.extractUniqueCompletedDays(bookings);
      expect(days, isEmpty);
    });

    test('counts completed booking without sub-sessions', () {
      final bookings = [
        const BookingModel(
          id: '1',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-11-01',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
      ];

      final days = TrainingInsightsCalculator.extractUniqueCompletedDays(bookings);
      expect(days.length, 1);
      expect(days.first, DateTime(2026, 11, 1));
    });

    test('deduplicates multiple completed sessions on the same day', () {
      final bookings = [
        const BookingModel(
          id: '1',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-11-01',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
        const BookingModel(
          id: '2',
          coachUid: 'c2',
          traineeUid: 't1',
          sport: 'Boxing',
          date: '2026-11-01',
          startTime: '16:00',
          endTime: '17:00',
          status: 'completed',
        ),
      ];

      final days = TrainingInsightsCalculator.extractUniqueCompletedDays(bookings);
      expect(days.length, 1);

      final countDay = TrainingInsightsCalculator.calculateUniqueDays(
        completedDays: days,
        period: TrainingPeriod.day,
        referenceDate: DateTime(2026, 11, 1),
      );
      expect(countDay, 1);

      final countMonth = TrainingInsightsCalculator.calculateUniqueDays(
        completedDays: days,
        period: TrainingPeriod.month,
        referenceDate: DateTime(2026, 11, 1),
      );
      expect(countMonth, 1);
    });

    test('correctly calculates day, month, and year stats across multiple days', () {
      final bookings = [
        const BookingModel(
          id: '1',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-11-01',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
        const BookingModel(
          id: '2',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-11-05',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
        const BookingModel(
          id: '3',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-10-15',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
        const BookingModel(
          id: '4',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2025-11-01',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
      ];

      final days = TrainingInsightsCalculator.extractUniqueCompletedDays(bookings);
      expect(days.length, 4);

      // Day: 2026-11-01 -> 1
      expect(
        TrainingInsightsCalculator.calculateUniqueDays(
          completedDays: days,
          period: TrainingPeriod.day,
          referenceDate: DateTime(2026, 11, 1),
        ),
        1,
      );

      // Day: 2026-11-02 -> 0 (no session)
      expect(
        TrainingInsightsCalculator.calculateUniqueDays(
          completedDays: days,
          period: TrainingPeriod.day,
          referenceDate: DateTime(2026, 11, 2),
        ),
        0,
      );

      // Month: November 2026 -> 2 (Nov 1, Nov 5)
      expect(
        TrainingInsightsCalculator.calculateUniqueDays(
          completedDays: days,
          period: TrainingPeriod.month,
          referenceDate: DateTime(2026, 11, 20),
        ),
        2,
      );

      // Month: October 2026 -> 1 (Oct 15)
      expect(
        TrainingInsightsCalculator.calculateUniqueDays(
          completedDays: days,
          period: TrainingPeriod.month,
          referenceDate: DateTime(2026, 10, 1),
        ),
        1,
      );

      // Year: 2026 -> 3 (Nov 1, Nov 5, Oct 15)
      expect(
        TrainingInsightsCalculator.calculateUniqueDays(
          completedDays: days,
          period: TrainingPeriod.year,
          referenceDate: DateTime(2026, 6, 1),
        ),
        3,
      );

      // Year: 2025 -> 1 (Nov 1 2025)
      expect(
        TrainingInsightsCalculator.calculateUniqueDays(
          completedDays: days,
          period: TrainingPeriod.year,
          referenceDate: DateTime(2025, 1, 1),
        ),
        1,
      );
    });

    test('extracts completed sub-sessions from monthly booking', () {
      final monthlyBooking = BookingModel(
        id: 'm1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Gym',
        bookingType: 'monthly',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        status: 'confirmed',
        sessions: const [
          BookingSessionModel(
            id: 's1',
            date: '2026-11-02',
            startTime: '10:00',
            endTime: '11:00',
            status: 'completed',
          ),
          BookingSessionModel(
            id: 's2',
            date: '2026-11-04',
            startTime: '10:00',
            endTime: '11:00',
            status: 'scheduled',
          ),
          BookingSessionModel(
            id: 's3',
            date: '2026-11-06',
            startTime: '10:00',
            endTime: '11:00',
            status: 'completed',
          ),
        ],
      );

      final days = TrainingInsightsCalculator.extractUniqueCompletedDays([monthlyBooking]);
      expect(days.length, 2);
      expect(days.contains(DateTime(2026, 11, 2)), isTrue);
      expect(days.contains(DateTime(2026, 11, 6)), isTrue);
    });
  });

  group('TrainingPeriodNavigator', () {
    test('computes previous and next date correctly', () {
      final base = DateTime(2026, 11, 15);

      final prevDay = TrainingPeriodNavigator.computePreviousDate(TrainingPeriod.day, base);
      expect(prevDay, DateTime(2026, 11, 14));

      final nextDay = TrainingPeriodNavigator.computeNextDate(TrainingPeriod.day, base);
      expect(nextDay, DateTime(2026, 11, 16));

      final prevMonth = TrainingPeriodNavigator.computePreviousDate(TrainingPeriod.month, base);
      expect(prevMonth.month, 10);

      final nextMonth = TrainingPeriodNavigator.computeNextDate(TrainingPeriod.month, base);
      expect(nextMonth.month, 12);

      final prevYear = TrainingPeriodNavigator.computePreviousDate(TrainingPeriod.year, base);
      expect(prevYear.year, 2025);

      final nextYear = TrainingPeriodNavigator.computeNextDate(TrainingPeriod.year, base);
      expect(nextYear.year, 2027);
    });

    test('canGoForward returns false for today', () {
      final now = DateTime.now();
      expect(
        TrainingPeriodNavigator.canGoForward(TrainingPeriod.day, now),
        isFalse,
      );
      expect(
        TrainingPeriodNavigator.canGoForward(TrainingPeriod.month, now),
        isFalse,
      );
      expect(
        TrainingPeriodNavigator.canGoForward(TrainingPeriod.year, now),
        isFalse,
      );
    });

    test('canGoForward returns true for past dates', () {
      final past = DateTime(2020, 1, 1);
      expect(
        TrainingPeriodNavigator.canGoForward(TrainingPeriod.day, past),
        isTrue,
      );
      expect(
        TrainingPeriodNavigator.canGoForward(TrainingPeriod.month, past),
        isTrue,
      );
      expect(
        TrainingPeriodNavigator.canGoForward(TrainingPeriod.year, past),
        isTrue,
      );
    });
  });
}

