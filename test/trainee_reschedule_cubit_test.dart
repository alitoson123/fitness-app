import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/trainee_bookings/data/repos/trainee_bookings_repo.dart';
import 'package:fitness_app/features/trainee_bookings/presentation/view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTraineeBookingsRepo implements TraineeBookingsRepo {
  bool approveCalled = false;
  bool rejectCalled = false;
  String? lastBookingId;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<BookingModel>> getTraineeBookingsStream(String traineeUid) =>
      Stream.value([]);

  @override
  Future<Either<Failure, void>> approveReschedule({
    required BookingModel booking,
  }) async {
    approveCalled = true;
    lastBookingId = booking.id;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> rejectReschedule({
    required String bookingId,
  }) async {
    rejectCalled = true;
    lastBookingId = bookingId;
    return const Right(null);
  }
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

    test('approveReschedule calls repository and emits reschedule_approved', () async {
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

      await cubit.approveReschedule(booking);

      expect(fakeRepo.approveCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-99');
      expect(cubit.state.successMessage, 'reschedule_approved');
    });

    test('rejectReschedule calls repository and emits reschedule_rejected', () async {
      await cubit.rejectReschedule('book-99');

      expect(fakeRepo.rejectCalled, isTrue);
      expect(fakeRepo.lastBookingId, 'book-99');
      expect(cubit.state.successMessage, 'reschedule_rejected');
    });
  });
}
