import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/features/coach_dashboard/data/repos/coach_bookings_repo.dart';
import 'package:fitness_app/features/coach_dashboard/presentation/view_model/coach_bookings_cubit/coach_bookings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCoachBookingsRepo implements CoachBookingsRepo {
  bool requestRescheduleCalled = false;
  bool acceptRescheduleCalled = false;
  bool declineRescheduleCalled = false;
  bool updateBookingStatusCalled = false;
  bool requestMonthlyCalled = false;
  bool acceptMonthlyCalled = false;
  bool declineMonthlyCalled = false;
  bool markCompletedCalled = false;
  String? lastBookingId;
  String? lastSessionId;
  String? lastStatus;
  String? lastProposedDate;
  String? lastReason;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<BookingModel>> getCoachBookingsStream(String coachUid) =>
      Stream.value([]);

  Future<Either<Failure, void>> _status(String bookingId, String status, [String? reason]) async {
    updateBookingStatusCalled = true;
    lastBookingId = bookingId;
    lastStatus = status;
    lastReason = reason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> approve(String bookingId) => _status(bookingId, 'confirmed');

  @override
  Future<Either<Failure, void>> reject(String bookingId, {String? reason}) =>
      _status(bookingId, 'rejected', reason);

  @override
  Future<Either<Failure, void>> completeBooking(String bookingId) =>
      _status(bookingId, 'completed');

  @override
  Future<Either<Failure, void>> requestReschedule({
    required String bookingId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) async {
    requestRescheduleCalled = true;
    lastBookingId = bookingId;
    lastProposedDate = proposedDate;
    lastReason = reason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> acceptReschedule(String bookingId) async {
    acceptRescheduleCalled = true;
    lastBookingId = bookingId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> declineReschedule(
    String bookingId, {
    String? declineReason,
  }) async {
    declineRescheduleCalled = true;
    lastBookingId = bookingId;
    lastReason = declineReason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> requestMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) async {
    requestMonthlyCalled = true;
    lastBookingId = bookingId;
    lastSessionId = sessionId;
    lastProposedDate = proposedDate;
    lastReason = reason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> acceptMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) async {
    acceptMonthlyCalled = true;
    lastBookingId = bookingId;
    lastSessionId = sessionId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> declineMonthlySessionReschedule({
    required String bookingId,
    required String sessionId,
  }) async {
    declineMonthlyCalled = true;
    lastBookingId = bookingId;
    lastSessionId = sessionId;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> markSessionCompleted({
    required String bookingId,
    required String sessionId,
  }) async {
    markCompletedCalled = true;
    lastBookingId = bookingId;
    lastSessionId = sessionId;
    return const Right(null);
  }
}

void main() {
  group('CoachBookingsCubit Reschedule & Monthly Tests', () {
    late FakeCoachBookingsRepo fakeRepo;
    late CoachBookingsCubit cubit;

    setUp(() {
      fakeRepo = FakeCoachBookingsRepo();
      cubit = CoachBookingsCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    test('requestReschedule successfully calls repository and emits rescheduled success', () async {
      const booking = BookingModel(
        id: 'book-1',
        coachUid: 'coach-1',
        traineeUid: 'trainee-1',
        sport: 'Gym',
        date: '2026-10-15',
        startTime: '10:00',
        endTime: '11:00',
        status: 'confirmed',
      );

      await cubit.requestReschedule(
        booking: booking,
        proposedDate: '2026-10-16',
        proposedStartTime: '14:00',
        proposedEndTime: '15:00',
        reason: 'Emergency at home',
      );

      expect(fakeRepo.requestRescheduleCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-1');
      expect(fakeRepo.lastProposedDate, '2026-10-16');
      expect(fakeRepo.lastReason, 'Emergency at home');
      expect(cubit.state.successMessage, 'rescheduled');
      expect(cubit.state.actionInProgressBookingId, isNull);
    });

    test('requestMonthlySessionReschedule calls repo and emits rescheduled', () async {
      final booking = BookingModel(
        id: 'book-monthly-1',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Swimming',
        bookingType: 'monthly',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        sessions: const [
          BookingSessionModel(id: 'sess-1', date: '2026-11-01', startTime: '10:00', endTime: '11:00'),
        ],
      );

      await cubit.requestMonthlySessionReschedule(
        booking: booking,
        sessionId: 'sess-1',
        proposedDate: '2026-11-03',
        proposedStartTime: '12:00',
        proposedEndTime: '13:00',
        reason: 'Pool maintenance',
      );

      expect(fakeRepo.requestMonthlyCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-1');
      expect(fakeRepo.lastSessionId, 'sess-1');
      expect(fakeRepo.lastProposedDate, '2026-11-03');
      expect(cubit.state.successMessage, 'rescheduled');
    });

    test('acceptMonthlySessionReschedule calls repo and emits reschedule_accepted', () async {
      await cubit.acceptMonthlySessionReschedule('book-monthly-1', 'sess-1');

      expect(fakeRepo.acceptMonthlyCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-1');
      expect(fakeRepo.lastSessionId, 'sess-1');
      expect(cubit.state.successMessage, 'reschedule_accepted');
    });

    test('declineMonthlySessionReschedule calls repo and emits reschedule_declined', () async {
      await cubit.declineMonthlySessionReschedule('book-monthly-1', 'sess-1');

      expect(fakeRepo.declineMonthlyCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-1');
      expect(fakeRepo.lastSessionId, 'sess-1');
      expect(cubit.state.successMessage, 'reschedule_declined');
    });

    test('completeBooking calls repo and emits booking_completed', () async {
      await cubit.completeBooking('book-1');

      expect(fakeRepo.lastStatus, 'completed');
      expect(fakeRepo.lastBookingId, 'book-1');
      expect(cubit.state.successMessage, 'booking_completed');
    });

    test('markSessionCompleted calls repo and emits session_completed', () async {
      await cubit.markSessionCompleted('book-monthly-1', 'sess-1');

      expect(fakeRepo.markCompletedCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-1');
      expect(fakeRepo.lastSessionId, 'sess-1');
      expect(cubit.state.successMessage, 'session_completed');
    });

    test('acceptReschedule calls repo and emits reschedule_accepted', () async {
      final booking = BookingModel(
        id: 'book-single-resched',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Gym',
        bookingType: 'session',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        proposedDate: '2026-11-02',
        proposedStartTime: '11:00',
        proposedEndTime: '12:00',
        rescheduledBy: 'trainee',
      );

      await cubit.acceptReschedule(booking);

      expect(fakeRepo.acceptRescheduleCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-single-resched');
      expect(cubit.state.successMessage, 'reschedule_accepted');
    });

    test('declineReschedule calls repo and emits reschedule_declined', () async {
      await cubit.declineReschedule(
        'book-single-resched',
        reason: 'Coach busy at proposed slot',
      );

      expect(fakeRepo.declineRescheduleCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-single-resched');
      expect(fakeRepo.lastReason, 'Coach busy at proposed slot');
      expect(cubit.state.successMessage, 'reschedule_declined');
    });
  });
}
