import 'package:fitness_app/features/booking_request/data/models/busy_range.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/repos/booking_request_repo.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_builder_helper.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_request_cubit.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/coach_setup/data/models/sport_location_model.dart';
import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuth implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  User? get currentUser => null;
}

class _FakeRepo implements BookingRequestRepo {
  BookingModel? lastBooking;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  @override
  AuthService get authService => _FakeAuth();
  @override
  Future<Either<Failure, List<BusyRange>>> getBusyRanges({
    required String coachUid,
    required String date,
    int sessionDurationMinutes = 60,
  }) async => const Right([]);
  @override
  Future<TraineeProfileModel?> getCurrentTrainee() async =>
      const TraineeProfileModel(uid: 't1', name: 'Trainee Sam');
  @override
  Future<Either<Failure, String>> createBooking(BookingModel booking) async {
    lastBooking = booking;
    return const Right('b_ok');
  }
}

void main() {
  late _FakeRepo repo;
  late BookingRequestCubit cubit;

  final coachWithMultiLocations = CoachProfileModel(
    uid: 'coach_123',
    name: 'Coach Alex',
    sports: const ['Football', 'Fitness'],
    sportLocations: const [
      SportLocationModel(
        sport: 'Football',
        isOnline: false,
        locations: ['Camp Nou Academy', 'City Field'],
      ),
      SportLocationModel(sport: 'Fitness', isOnline: true, locations: []),
    ],
  );

  setUp(() {
    repo = _FakeRepo();
    cubit = BookingRequestCubit(repository: repo);
  });

  tearDown(() => cubit.close());

  group('BookingRequestCubit Location Delivery Tests', () {
    test(
      'when sport has multiple locations, trainee must choose before submit is ready',
      () {
        cubit.init(coachWithMultiLocations);
        cubit.selectSport('Football');
        expect(cubit.state.isDeliverySelected, isFalse);
        expect(cubit.state.isSubmitReady, isFalse);

        cubit.selectTrainingLocation('Camp Nou Academy');
        expect(cubit.state.selectedLocation, 'Camp Nou Academy');
        expect(cubit.state.isOnlineTraining, isFalse);
        expect(cubit.state.isDeliverySelected, isTrue);
      },
    );

    test('when sport is online only, cubit auto-selects online mode', () {
      cubit.init(coachWithMultiLocations);
      cubit.selectSport('Fitness');
      expect(cubit.state.isOnlineTraining, isTrue);
      expect(cubit.state.selectedLocation, isNull);
      expect(cubit.state.isDeliverySelected, isTrue);
    });

    test('manual toggle between online and location selection', () {
      cubit.init(coachWithMultiLocations);
      cubit.selectSport('Football');
      cubit.selectTrainingLocation('City Field');
      expect(cubit.state.selectedLocation, 'City Field');

      cubit.selectOnlineTraining();
      expect(cubit.state.isOnlineTraining, isTrue);
      expect(cubit.state.selectedLocation, isNull);
    });

    test(
      'BookingBuilderHelper encodes trainingLocation and isOnline flag properly',
      () {
        cubit.init(coachWithMultiLocations);
        cubit.selectSport('Football');
        cubit.selectTrainingLocation('City Field');
        cubit.selectSlot('10:00');

        final booking = BookingBuilderHelper.buildFromState(
          state: cubit.state,
          traineeUid: 't1',
          traineeName: 'Trainee Sam',
        );
        expect(booking.trainingLocation, 'City Field');
        expect(booking.isOnline, isFalse);
        expect(booking.sport, 'Football');

        cubit.selectOnlineTraining();
        final onlineBooking = BookingBuilderHelper.buildFromState(
          state: cubit.state,
          traineeUid: 't1',
          traineeName: 'Trainee Sam',
        );
        expect(onlineBooking.trainingLocation, 'Online');
        expect(onlineBooking.isOnline, isTrue);
      },
    );
  });
}
