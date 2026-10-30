import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
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
      expect(booking.monthlyScheduleNotes, isNull);
    });

    test('monthly booking type parsed properly from json', () {
      final json = {
        'id': 'b_monthly_1',
        'coachUid': 'c1',
        'coachName': 'Coach Mike',
        'traineeUid': 't1',
        'traineeName': 'Jane Doe',
        'sport': 'Boxing',
        'bookingType': 'monthly',
        'date': '2026-11-05',
        'startTime': 'Flexible',
        'endTime': 'Flexible',
        'price': 250.0,
        'currency': 'USD',
        'durationMonths': 2,
        'monthlyScheduleNotes': '3 days/week, prefer evenings',
        'notes': 'Goal: lose 5kg',
        'status': 'pending',
      };

      final booking = BookingModel.fromJson(json);

      expect(booking.bookingType, 'monthly');
      expect(booking.isMonthly, isTrue);
      expect(booking.isSession, isFalse);
      expect(booking.durationMonths, 2);
      expect(booking.price, 250.0);
      expect(booking.currency, 'USD');
      expect(booking.monthlyScheduleNotes, '3 days/week, prefer evenings');
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
    });

    test('toMap writes bookingType, USD currency, and durationMonths', () {
      const booking = BookingModel(
        id: 'b_map_1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Swimming',
        bookingType: 'monthly',
        date: '2026-11-10',
        startTime: 'Flexible',
        endTime: 'Flexible',
        price: 300.0,
        durationMonths: 1,
        monthlyScheduleNotes: 'Mon/Wed/Fri 6pm',
      );

      final map = booking.toMap();

      expect(map['bookingType'], 'monthly');
      expect(map['currency'], 'USD');
      expect(map['durationMonths'], 1);
      expect(map['price'], 300.0);
      expect(map['monthlyScheduleNotes'], 'Mon/Wed/Fri 6pm');
    });

    test('copyWith properly updates bookingType and monthly fields', () {
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
        monthlyScheduleNotes: '4 days/week',
        durationMonths: 2,
      );

      expect(updated.bookingType, 'monthly');
      expect(updated.isMonthly, isTrue);
      expect(updated.price, 200.0);
      expect(updated.monthlyScheduleNotes, '4 days/week');
      expect(updated.durationMonths, 2);
      expect(updated.sport, 'Fitness');
    });
  });
}

