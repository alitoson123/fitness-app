import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/trainee_profile/data/repos/trainee_profile_repo.dart';
import 'package:fitness_app/features/trainee_profile/presentation/helpers/training_insights_calculator.dart';
import 'package:fitness_app/features/trainee_profile/presentation/view_model/training_insights_cubit/training_insights_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTraineeProfileRepo implements TraineeProfileRepo {
  Either<Failure, List<BookingModel>> bookingsResult = const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Either<Failure, List<BookingModel>>> getTraineeBookings() async {
    return bookingsResult;
  }
}

void main() {
  late FakeTraineeProfileRepo fakeRepo;
  late TrainingInsightsCubit cubit;

  setUp(() {
    fakeRepo = FakeTraineeProfileRepo();
    cubit = TrainingInsightsCubit(repository: fakeRepo);
  });

  tearDown(() {
    cubit.close();
  });

  group('TrainingInsightsCubit', () {
    test('initial state has default Day period and empty bookings', () {
      expect(cubit.state.selectedPeriod, TrainingPeriod.day);
      expect(cubit.state.bookings, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    test('loadInsights emits loaded bookings on success', () async {
      final sampleBookings = [
        const BookingModel(
          id: 'b1',
          coachUid: 'c1',
          traineeUid: 't1',
          sport: 'Gym',
          date: '2026-11-01',
          startTime: '10:00',
          endTime: '11:00',
          status: 'completed',
        ),
      ];
      fakeRepo.bookingsResult = Right(sampleBookings);

      await cubit.loadInsights();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.bookings.length, 1);
      expect(cubit.state.errorMessage, isNull);
    });

    test('loadInsights emits error message on failure', () async {
      fakeRepo.bookingsResult = Left(ServerFailure(errorMessage: 'Network error'));

      await cubit.loadInsights();

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.errorMessage, 'Network error');
      expect(cubit.state.bookings, isEmpty);
    });

    test('selectPeriod switches period and resets date', () {
      cubit.previousPeriod(); // shifts to past day
      cubit.selectPeriod(TrainingPeriod.month);

      expect(cubit.state.selectedPeriod, TrainingPeriod.month);
      final now = DateTime.now();
      expect(cubit.state.selectedDate.month, now.month);
      expect(cubit.state.selectedDate.year, now.year);
    });

    test('previousPeriod and nextPeriod navigate appropriately', () {
      final initialDate = cubit.state.selectedDate;
      cubit.previousPeriod();
      expect(
        cubit.state.selectedDate.day,
        initialDate.subtract(const Duration(days: 1)).day,
      );

      // Now we can go forward back to initialDate
      expect(cubit.state.canGoForward, isTrue);
      cubit.nextPeriod();
      expect(cubit.state.selectedDate.day, initialDate.day);
    });
  });
}

