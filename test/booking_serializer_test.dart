import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_serializer.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingSerializer & BookingModel Refactoring Tests', () {
    test('toMap for single session: excludes sessions array and durationMonths', () {
      final booking = BookingModel(
        id: 's_doc_1',
        coachUid: 'coach_1',
        traineeUid: 'trainee_1',
        sport: 'Gym',
        bookingType: 'session',
        date: '2026-11-20',
        startTime: '10:00',
        endTime: '11:00',
        price: 50.0,
        status: 'pending',
      );

      final map = BookingSerializer.toMap(booking);

      expect(map.containsKey('sessions'), isFalse);
      expect(map.containsKey('durationMonths'), isFalse);
      expect(map['date'], equals('2026-11-20'));
      expect(map['startTime'], equals('10:00'));
      expect(map['endTime'], equals('11:00'));
      expect(map['status'], equals('pending'));
      expect(map['bookingType'], equals('session'));
    });

    test('toMap for monthly package: includes sessions array and durationMonths', () {
      final booking = BookingModel(
        id: 'm_doc_1',
        coachUid: 'coach_1',
        traineeUid: 'trainee_1',
        sport: 'Gym',
        bookingType: 'monthly',
        durationMonths: 1,
        date: '2026-11-01',
        startTime: '18:00',
        endTime: '19:00',
        sessions: const [
          BookingSessionModel(
            id: 's_1',
            date: '2026-11-01',
            startTime: '18:00',
            endTime: '19:00',
            status: 'completed',
          ),
          BookingSessionModel(
            id: 's_2',
            date: '2026-11-04',
            startTime: '18:00',
            endTime: '19:00',
            status: 'scheduled',
          ),
        ],
        status: 'confirmed',
      );

      final map = BookingSerializer.toMap(booking);

      expect(map.containsKey('sessions'), isTrue);
      expect(map['durationMonths'], equals(1));
      expect((map['sessions'] as List).length, equals(2));
      expect(map['bookingType'], equals('monthly'));
    });

    test('fromJson self-heals legacy single session with stale sessions[0] data (Doc 2 case)', () {
      final legacyJson = {
        'id': 'yDcBxhkinysrjt3yJove',
        'bookingType': 'session',
        'coachUid': 'coach_1',
        'traineeUid': 'trainee_1',
        'sport': 'basketball',
        'date': '2026-11-22',
        'startTime': '19:00',
        'endTime': '20:00',
        'status': 'reschedule_pending',
        'proposedDate': '2026-11-21',
        'proposedStartTime': '20:00',
        'proposedEndTime': '21:00',
        // Stale session array in legacy document:
        'sessions': [
          {
            'id': 's_1',
            'date': '2026-11-04', // Old date!
            'startTime': '18:00',
            'endTime': '19:00',
            'status': 'scheduled',
          }
        ],
      };

      final booking = BookingSerializer.fromJson(legacyJson);

      expect(booking.isSession, isTrue);
      expect(booking.sessions.length, equals(1));
      // Self-healed: reads root date and root status, ignoring stale sessions[0]
      expect(booking.sessions.first.date, equals('2026-11-22'));
      expect(booking.sessions.first.startTime, equals('19:00'));
      expect(booking.sessions.first.endTime, equals('20:00'));
      expect(booking.sessions.first.status, equals('reschedule_pending'));
      expect(booking.sessions.first.proposedDate, equals('2026-11-21'));
    });

    test('fromJson self-heals legacy completed single session (Doc 1 case)', () {
      final legacyJson = {
        'id': 'II9m6pyeddhGu4m0d6iS',
        'bookingType': 'session',
        'coachUid': 'coach_1',
        'traineeUid': 'trainee_1',
        'sport': 'Gym',
        'date': '2026-11-02',
        'startTime': '22:00',
        'endTime': '23:00',
        'status': 'completed',
        'updatedAt': '2026-11-03T15:42:21.498Z', // ISO String
        'sessions': [
          {
            'id': 's_1',
            'date': '2026-11-02',
            'startTime': '22:00',
            'endTime': '23:00',
            'status': 'scheduled', // Stale scheduled status!
          }
        ],
      };

      final booking = BookingSerializer.fromJson(legacyJson);

      expect(booking.status, equals('completed'));
      expect(booking.sessions.first.status, equals('completed'));
      expect(booking.completedSessionsCount, equals(1));
      expect(booking.progressRatio, equals(1.0));
      expect(booking.updatedAt, isNotNull);
    });

    test('BookingModel.copyWith updates single session in memory', () {
      final booking = BookingModel(
        id: 'b1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Gym',
        date: '2026-11-20',
        startTime: '10:00',
        endTime: '11:00',
        status: 'pending',
      );

      final completedBooking = booking.copyWith(status: 'completed');

      expect(completedBooking.status, equals('completed'));
      expect(completedBooking.sessions.first.status, equals('completed'));
      expect(completedBooking.completedSessionsCount, equals(1));
    });
  });
}
