import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingSessionModel & BookingModel.sessions Tests', () {
    test('BookingSessionModel serialization and deserialization', () {
      const session = BookingSessionModel(
        id: 's_1',
        date: '2026-11-05',
        startTime: '10:00',
        endTime: '11:00',
        status: 'scheduled',
      );

      final map = session.toMap();
      expect(map['id'], 's_1');
      expect(map['date'], '2026-11-05');
      expect(map['startTime'], '10:00');
      expect(map['endTime'], '11:00');
      expect(map['status'], 'scheduled');

      final fromMap = BookingSessionModel.fromJson(map);
      expect(fromMap, equals(session));
    });

    test('BookingModel backward compatibility: empty sessions if absent in json', () {
      final json = {
        'id': 'b1',
        'coachUid': 'c1',
        'traineeUid': 't1',
        'sport': 'Boxing',
        'bookingType': 'monthly',
        'date': '2026-11-01',
        'startTime': 'Flexible',
        'endTime': 'Flexible',
      };

      final booking = BookingModel.fromJson(json);
      expect(booking.sessions, isEmpty);
      expect(booking.sessionsCount, 1);
    });

    test('BookingModel parses 8 sessions properly and serializes toMap', () {
      final sessions = List.generate(
        8,
        (i) => BookingSessionModel(
          id: 's_$i',
          date: '2026-11-${(i + 1).toString().padLeft(2, '0')}',
          startTime: '18:00',
          endTime: '19:00',
        ),
      );

      final booking = BookingModel(
        id: 'b_monthly_8',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Fitness',
        bookingType: 'monthly',
        date: '2026-11-01',
        startTime: '18:00',
        endTime: '19:00',
        price: 300.0,
        sessions: sessions,
      );

      expect(booking.sessions.length, 8);
      expect(booking.sessionsCount, 8);

      final map = booking.toMap();
      expect(map['sessions'], isA<List>());
      expect((map['sessions'] as List).length, 8);

      final reconstructed = BookingModel.fromJson(map);
      expect(reconstructed.sessions.length, 8);
      expect(reconstructed.sessions.first.id, 's_0');
      expect(reconstructed.sessions.last.id, 's_7');
    });
  });
}

