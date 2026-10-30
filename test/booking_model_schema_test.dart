import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingModel Schema Evolution Tests (Milestone 3)', () {
    test('default values are session, duration 1, and USD currency', () {
      const booking = BookingModel(
        id: 'b_default',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'CrossFit',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
      );

      expect(booking.bookingType, 'session');
      expect(booking.isSession, isTrue);
      expect(booking.isMonthly, isFalse);
      expect(booking.durationMonths, 1);
      expect(booking.currency, 'USD');
      expect(booking.sessions, isEmpty);
    });

    test('monthly booking type parsed properly from json with sessions', () {
      final json = {
        'id': 'b_monthly_1',
        'coachUid': 'c1',
        'coachName': 'Coach Mike',
        'traineeUid': 't1',
        'traineeName': 'Jane Doe',
        'sport': 'Boxing',
        'bookingType': 'monthly',
        'date': '2026-11-05',
        'startTime': '18:00',
        'endTime': '19:00',
        'price': 250.0,
        'currency': 'USD',
        'durationMonths': 1,
        'sessions': [
          {
            'id': 's1',
            'date': '2026-11-05',
            'startTime': '18:00',
            'endTime': '19:00',
            'status': 'scheduled',
          }
        ],
        'notes': 'Goal: lose 5kg',
        'status': 'pending',
      };

      final booking = BookingModel.fromJson(json);

      expect(booking.bookingType, 'monthly');
      expect(booking.isMonthly, isTrue);
      expect(booking.isSession, isFalse);
      expect(booking.durationMonths, 1);
      expect(booking.price, 250.0);
      expect(booking.currency, 'USD');
      expect(booking.sessions.length, 1);
      expect(booking.sessions.first.date, '2026-11-05');
      expect(booking.notes, 'Goal: lose 5kg');
    });

    test('backward compatibility: missing bookingType defaults to session', () {
      final json = {
        'id': 'b_legacy',
        'coachUid': 'c1',
        'traineeUid': 't1',
        'sport': 'Fitness',
        'date': '2026-10-10',
        'startTime': '09:00',
        'endTime': '10:00',
        'price': 40.0,
      };

      final booking = BookingModel.fromJson(json);

      expect(booking.bookingType, 'session');
      expect(booking.isSession, isTrue);
      expect(booking.durationMonths, 1);
      expect(booking.currency, 'USD');
      expect(booking.sessions, isEmpty);
    });

    test('toMap writes bookingType, USD currency, and sessions', () {
      const booking = BookingModel(
        id: 'b_map_1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Swimming',
        bookingType: 'monthly',
        date: '2026-11-10',
        startTime: '10:00',
        endTime: '11:00',
        price: 300.0,
        durationMonths: 1,
        sessions: [
          BookingSessionModel(
            id: 's1',
            date: '2026-11-10',
            startTime: '10:00',
            endTime: '11:00',
          )
        ],
      );

      final map = booking.toMap();

      expect(map['bookingType'], 'monthly');
      expect(map['currency'], 'USD');
      expect(map['durationMonths'], 1);
      expect(map['price'], 300.0);
      expect(map['sessions'], isA<List>());
      expect((map['sessions'] as List).length, 1);
    });

    test('copyWith properly updates bookingType and sessions fields', () {
      const original = BookingModel(
        id: 'b1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Fitness',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        price: 50.0,
      );

      final updated = original.copyWith(
        bookingType: 'monthly',
        price: 200.0,
        sessions: const [
          BookingSessionModel(
            id: 's_new',
            date: '2026-11-02',
            startTime: '12:00',
            endTime: '13:00',
          ),
        ],
        durationMonths: 1,
      );

      expect(updated.bookingType, 'monthly');
      expect(updated.isMonthly, isTrue);
      expect(updated.price, 200.0);
      expect(updated.sessions.length, 1);
      expect(updated.sessions.first.id, 's_new');
      expect(updated.sport, 'Fitness');
    });

    test('copyWith(id: newId) preserves all monthly fields and toMap outputs them', () {
      final sessions = List.generate(
        8,
        (i) => BookingSessionModel(
          id: 's_$i',
          date: '2026-11-${(i + 1).toString().padLeft(2, '0')}',
          startTime: '17:00',
          endTime: '18:00',
        ),
      );

      final initial = BookingModel(
        id: '',
        coachUid: 'c1',
        coachName: 'ali coach 2',
        traineeUid: 't1',
        traineeName: 'Ali trainee',
        sport: 'Gym',
        bookingType: 'monthly',
        date: '2026-11-01',
        startTime: '17:00',
        endTime: '18:00',
        price: 300.0,
        sessions: sessions,
        notes: 'test monthly',
      );

      final fullBooking = initial.copyWith(id: 'generated_doc_id');
      final map = fullBooking.toMap();

      expect(map['id'], 'generated_doc_id');
      expect(map['bookingType'], 'monthly');
      expect(map['price'], 300.0);
      expect(map['notes'], 'test monthly');
      expect(map['sport'], 'Gym');
      expect(map['sessions'], isA<List>());
      expect((map['sessions'] as List).length, 8);
    });
  });
}
