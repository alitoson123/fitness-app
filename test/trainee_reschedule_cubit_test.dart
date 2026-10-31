import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/trainee_bookings/data/repos/trainee_bookings_repo.dart';
import 'package:fitness_app/features/trainee_bookings/presentation/view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTraineeBookingsRepo implements TraineeBookingsRepo {
  bool acceptCalled = false;
  bool declineCalled = false;
  String? lastBookingId;
  String? lastDeclineReason;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<BookingModel>> getTraineeBookingsStream(String traineeUid) =>
      Stream.value([]);

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
    lastDeclineReason = declineReason;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> rejectReschedule({
    required String bookingId,
    String? declineReason,
  }) =>
      declineReschedule(bookingId: bookingId, declineReason: declineReason);
}

void main() {
  group('TraineeBookingsCubit Reschedule Tests', () {
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

    test('approveReschedule alias also calls repo and succeeds', () async {
      await cubit.approveReschedule(booking);

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
      expect(fakeRepo.lastDeclineReason, 'Schedule conflict on Thursday');
      expect(cubit.state.successMessage, 'reschedule_rejected');
    });

    test('rejectReschedule alias passes reason and succeeds', () async {
      await cubit.rejectReschedule('book-99', declineReason: 'Time conflict');

      expect(fakeRepo.declineCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-99');
      expect(fakeRepo.lastDeclineReason, 'Time conflict');
      expect(cubit.state.successMessage, 'reschedule_rejected');
    });
  });
}
