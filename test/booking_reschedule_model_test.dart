import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingModel Reschedule Tests', () {
    test('fromJson correctly parses proposed reschedule fields', () {
      final json = {
        'id': 'b123',
        'coachUid': 'c1',
        'coachName': 'Coach Alex',
        'traineeUid': 't1',
        'traineeName': 'John Doe',
        'sport': 'Boxing',
        'date': '2026-10-20',
        'startTime': '10:00',
        'endTime': '11:00',
        'status': 'reschedule_pending',
        'proposedDate': '2026-10-21',
        'proposedStartTime': '14:00',
        'proposedEndTime': '15:00',
        'rescheduleReason': 'Family emergency, need to move to tomorrow',
        'rescheduledBy': 'coach',
        'previousDate': '2026-10-20',
        'previousStartTime': '10:00',
        'previousEndTime': '11:00',
      };

      final booking = BookingModel.fromJson(json);

      expect(booking.id, 'b123');
      expect(booking.status, 'reschedule_pending');
      expect(booking.isReschedulePending, isTrue);
      expect(booking.proposedDate, '2026-10-21');
      expect(booking.proposedStartTime, '14:00');
      expect(booking.proposedEndTime, '15:00');
      expect(booking.rescheduleReason, 'Family emergency, need to move to tomorrow');
      expect(booking.rescheduledBy, 'coach');
      expect(booking.previousDate, '2026-10-20');
      expect(booking.previousStartTime, '10:00');
    });

    test('toMap correctly serializes reschedule and cancellation fields', () {
      const booking = BookingModel(
        id: 'b456',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Fitness',
        date: '2026-10-22',
        startTime: '09:00',
        endTime: '10:00',
        status: 'cancelled',
        cancellationReason: 'Reschedule declined by trainee',
      );

      final map = booking.toMap();

      expect(map['id'], 'b456');
      expect(map['status'], 'cancelled');
      expect(map['cancellationReason'], 'Reschedule declined by trainee');
    });
  });
}
