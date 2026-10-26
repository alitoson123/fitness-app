import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/coach_dashboard/data/repos/coach_bookings_repo.dart';
import 'package:fitness_app/features/coach_dashboard/presentation/view_model/coach_bookings_cubit/coach_bookings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeCoachBookingsRepo implements CoachBookingsRepo {
  bool requestRescheduleCalled = false;
  String? lastBookingId;
  String? lastProposedDate;
  String? lastReason;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<List<BookingModel>> getCoachBookingsStream(String coachUid) =>
      Stream.value([]);

  @override
  Future<Either<Failure, void>> requestReschedule({
    required String bookingId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String originalDate,
    required String originalStartTime,
    required String originalEndTime,
  }) async {
    requestRescheduleCalled = true;
    lastBookingId = bookingId;
    lastProposedDate = proposedDate;
    lastReason = reason;
    return const Right(null);
  }
}

void main() {
  group('CoachBookingsCubit Reschedule Tests', () {
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
  });
}
