import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/repos/booking_request_repo.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_request_cubit.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_request_state.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthService implements AuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  User? get currentUser => null;
}

class FakeMonthlyBookingRequestRepo implements BookingRequestRepo {
  BookingModel? lastCreatedBooking;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  AuthService get authService => FakeAuthService();

  @override
  Future<Either<Failure, List<String>>> getBookedSlots({
    required String coachUid,
    required String date,
  }) async {
    return const Right([]);
  }

  @override
  Future<TraineeProfileModel?> getCurrentTrainee() async {
    return const TraineeProfileModel(
      uid: 'trainee_123',
      name: 'Sarah Trainee',
    );
  }

  @override
  Future<Either<Failure, String>> createBooking(BookingModel booking) async {
    lastCreatedBooking = booking;
    return const Right('created_monthly_booking_id');
  }
}

void main() {
  group('BookingRequestCubit 8-Sessions Monthly Plan Tests', () {
    late FakeMonthlyBookingRequestRepo repo;
    late BookingRequestCubit cubit;
    late CoachProfileModel coach;

    setUp(() {
      repo = FakeMonthlyBookingRequestRepo();
      cubit = BookingRequestCubit(repository: repo);
      coach = const CoachProfileModel(
        uid: 'c1',
        name: 'Coach Sam',
        sports: ['Fitness'],
        sessionPriceUSD: 40.0,
        monthlyPriceUSD: 240.0,
        workingDays: [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday'
        ],
        workingHours: {'from': '09:00', 'to': '20:00'},
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('monthly mode is not submit ready until 8 sessions are selected', () {
      cubit.init(coach);
      cubit.selectBookingType('monthly');

      expect(cubit.state.isSubmitReady, isFalse);
      expect(cubit.state.isMonthlyComplete, isFalse);

      final now = DateTime.now();
      for (int i = 0; i < 7; i++) {
        cubit.toggleMonthlySession(now.add(Duration(days: i)), '10:00');
      }

      expect(cubit.state.selectedMonthlySessions.length, 7);
      expect(cubit.state.isSubmitReady, isFalse);

      // Add 8th session
      cubit.toggleMonthlySession(now.add(const Duration(days: 7)), '10:00');
      expect(cubit.state.selectedMonthlySessions.length, 8);
      expect(cubit.state.isMonthlyComplete, isTrue);
      expect(cubit.state.isSubmitReady, isTrue);
    });

    test('cannot exceed 8 sessions in manual selection', () {
      cubit.init(coach);
      cubit.selectBookingType('monthly');
      final now = DateTime.now();

      for (int i = 0; i < 10; i++) {
        cubit.toggleMonthlySession(now.add(Duration(days: i)), '10:00');
      }

      expect(cubit.state.selectedMonthlySessions.length, 8);
    });

    test('toggleMonthlySession replaces time slot or removes if tapped again', () {
      cubit.init(coach);
      cubit.selectBookingType('monthly');
      final day = DateTime.now();

      // Add session at 10:00
      cubit.toggleMonthlySession(day, '10:00');
      expect(cubit.state.selectedMonthlySessions.length, 1);
      expect(cubit.state.selectedMonthlySessions.first.startTime, '10:00');

      // Change time slot for same day to 11:00
      cubit.toggleMonthlySession(day, '11:00');
      expect(cubit.state.selectedMonthlySessions.length, 1);
      expect(cubit.state.selectedMonthlySessions.first.startTime, '11:00');

      // Tapping same slot removes it
      cubit.toggleMonthlySession(day, '11:00');
      expect(cubit.state.selectedMonthlySessions, isEmpty);
    });

    test('removeMonthlySession removes specific session by id', () {
      cubit.init(coach);
      cubit.selectBookingType('monthly');
      final now = DateTime.now();
      cubit.toggleMonthlySession(now, '10:00');
      cubit.toggleMonthlySession(now.add(const Duration(days: 1)), '10:00');

      expect(cubit.state.selectedMonthlySessions.length, 2);
      final firstId = cubit.state.selectedMonthlySessions.first.id;

      cubit.removeMonthlySession(firstId);
      expect(cubit.state.selectedMonthlySessions.length, 1);
      expect(cubit.state.selectedMonthlySessions.first.id, isNot(firstId));
    });

    test('submitBooking in monthly mode submits booking with 8 sessions', () async {
      cubit.init(coach);
      cubit.selectBookingType('monthly');
      final now = DateTime.now();
      for (int i = 0; i < 8; i++) {
        cubit.toggleMonthlySession(now.add(Duration(days: i)), '17:00');
      }

      await cubit.submitBooking();

      expect(cubit.state.status, BookingRequestStatus.success);
      expect(repo.lastCreatedBooking, isNotNull);
      final booking = repo.lastCreatedBooking!;
      expect(booking.bookingType, 'monthly');
      expect(booking.sessions.length, 8);
      expect(booking.price, 240.0);
      expect(booking.currency, 'USD');
      expect(booking.sessions.first.startTime, '17:00');
    });
  });
}

