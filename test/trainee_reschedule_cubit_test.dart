import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/trainee_bookings/data/repos/trainee_bookings_repo.dart';
import 'package:fitness_app/features/trainee_bookings/presentation/view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/fake_booking_store.dart';

class FakeTraineeBookingsRepo implements TraineeBookingsRepo {
  bool requestRescheduleCalled = false;
  bool acceptCalled = false;
  bool declineCalled = false;
  bool requestMonthlyCalled = false;
  bool acceptMonthlyCalled = false;
  bool declineMonthlyCalled = false;
  String? lastBookingId;
  String? lastSessionId;
  String? lastProposedDate;
  String? lastReason;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<BookingModel>> getTraineeBookingsStream(String traineeUid) =>
      Stream.value([]);

  @override
  Future<Either<Failure, void>> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
  }) async {
    requestRescheduleCalled = true;
    lastBookingId = booking.id;
    lastProposedDate = proposedDate;
    lastReason = reason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> acceptReschedule({
    required BookingModel booking,
  }) async {
    acceptCalled = true;
    lastBookingId = booking.id;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> approveReschedule({
    required BookingModel booking,
  }) =>
      acceptReschedule(booking: booking);

  @override
  Future<Either<Failure, void>> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) async {
    declineCalled = true;
    lastBookingId = bookingId;
    lastReason = declineReason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> rejectReschedule({
    required String bookingId,
    String? declineReason,
  }) =>
      declineReschedule(bookingId: bookingId, declineReason: declineReason);

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
}

void main() {
  setUpAll(() => S.load(const Locale('en')));

  group('TraineeBookingsCubit Reschedule & Monthly Tests', () {
    late FakeTraineeBookingsRepo fakeRepo;
    late TraineeBookingsCubit cubit;

    setUp(() {
      fakeRepo = FakeTraineeBookingsRepo();
      cubit = TraineeBookingsCubit(repository: fakeRepo);
    });

    tearDown(() {
      cubit.close();
    });

    const booking = BookingModel(
      id: 'book-99',
      coachUid: 'coach-1',
      traineeUid: 'trainee-1',
      sport: 'Crossfit',
      date: '2026-10-18',
      startTime: '08:00',
      endTime: '09:00',
      status: 'reschedule_pending',
      proposedDate: '2026-10-19',
      proposedStartTime: '11:00',
      proposedEndTime: '12:00',
    );

    test('acceptReschedule calls repo and emits reschedule_approved', () async {
      await cubit.acceptReschedule(booking);

      expect(fakeRepo.acceptCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-99');
      expect(cubit.state.successMessage, 'reschedule_approved');
    });

    test('declineReschedule calls repo with reason and emits message', () async {
      await cubit.declineReschedule(
        'book-99',
        declineReason: 'Schedule conflict on Thursday',
      );

      expect(fakeRepo.declineCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-99');
      expect(fakeRepo.lastReason, 'Schedule conflict on Thursday');
      expect(cubit.state.successMessage, 'reschedule_rejected');
    });

    test('requestReschedule calls repo and emits rescheduled', () async {
      final booking = BookingModel(
        id: 'book-single-trainee',
        coachUid: 'c1',
        traineeUid: 't1',
        sport: 'Gym',
        bookingType: 'session',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
      );

      await cubit.requestReschedule(
        booking: booking,
        proposedDate: '2026-11-03',
        proposedStartTime: '14:00',
        proposedEndTime: '15:00',
        reason: 'College exam',
      );

      expect(fakeRepo.requestRescheduleCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-single-trainee');
      expect(fakeRepo.lastProposedDate, '2026-11-03');
      expect(fakeRepo.lastReason, 'College exam');
      expect(cubit.state.successMessage, 'rescheduled');
    });

    test('requestMonthlySessionReschedule calls repo and emits rescheduled', () async {
      await cubit.requestMonthlySessionReschedule(
        bookingId: 'book-monthly-trainee',
        sessionId: 'sess-trainee-1',
        proposedDate: '2026-11-12',
        proposedStartTime: '17:00',
        proposedEndTime: '18:00',
        reason: 'Work overtime',
      );

      expect(fakeRepo.requestMonthlyCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-trainee');
      expect(fakeRepo.lastSessionId, 'sess-trainee-1');
      expect(fakeRepo.lastProposedDate, '2026-11-12');
      expect(fakeRepo.lastReason, 'Work overtime');
      expect(cubit.state.successMessage, 'rescheduled');
    });

    test('acceptMonthlySessionReschedule calls repo and emits reschedule_approved', () async {
      await cubit.acceptMonthlySessionReschedule('book-monthly-trainee', 'sess-trainee-1');

      expect(fakeRepo.acceptMonthlyCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-trainee');
      expect(fakeRepo.lastSessionId, 'sess-trainee-1');
      expect(cubit.state.successMessage, 'reschedule_approved');
    });

    test('declineMonthlySessionReschedule calls repo and emits reschedule_rejected', () async {
      await cubit.declineMonthlySessionReschedule(
        'book-monthly-trainee',
        'sess-trainee-1',
      );

      expect(fakeRepo.declineMonthlyCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-monthly-trainee');
      expect(fakeRepo.lastSessionId, 'sess-trainee-1');
      expect(cubit.state.successMessage, 'reschedule_rejected');
    });

    test('TraineeBookingsRepo.declineReschedule restores confirmed status without cancelling', () async {
      final store = FakeBookingStore()
        ..put(const BookingModel(
          id: 'booking-single-1',
          coachUid: 'coach-1',
          traineeUid: 'trainee-1',
          sport: 'football',
          date: '2030-01-10',
          startTime: '10:00',
          endTime: '11:00',
          status: 'reschedule_pending',
          rescheduledBy: 'coach',
          proposedDate: '2030-01-12',
          proposedStartTime: '12:00',
          proposedEndTime: '13:00',
        ));
      final actions = makeActionsRepo(store, uid: () => 'trainee-1').repo;
      final repo = TraineeBookingsRepo(firestoreService: store, actions: actions);

      final result = await repo.declineReschedule(
        bookingId: 'booking-single-1',
        declineReason: 'Coach proposed time does not fit my schedule',
      );

      expect(result.isRight(), isTrue);
      final data = store.docs['booking-single-1']!;
      expect(data['status'], 'confirmed');
      expect(data['previousDate'], isNull);
      expect(data['proposedDate'], isNull);
      expect(data['rescheduleDeclineReason'], 'Coach proposed time does not fit my schedule');
    });
  });
}
