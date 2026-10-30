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

class FakeBookingRequestRepo implements BookingRequestRepo {
  BookingModel? lastCreatedBooking;
  bool shouldFail = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  AuthService get authService => FakeAuthService();

  @override
  Future<Either<Failure, List<String>>> getBookedSlots({
    required String coachUid,
    required String date,
  }) async {
    return const Right(['10:00']);
  }

  @override
  Future<TraineeProfileModel?> getCurrentTrainee() async {
    return const TraineeProfileModel(
      uid: 'trainee_test_uid',
      name: 'John Doe',
    );
  }

  @override
  Future<Either<Failure, String>> createBooking(BookingModel booking) async {
    if (shouldFail) {
      return Left(ServerFailure(errorMessage: 'Network error'));
    }
    lastCreatedBooking = booking;
    return const Right('created_booking_id');
  }
}

void main() {
  group('BookingRequestCubit Dual Pricing & Booking Flow Tests (Milestone 3)', () {
    late FakeBookingRequestRepo repo;
    late BookingRequestCubit cubit;
    late CoachProfileModel testCoach;

    setUp(() {
      repo = FakeBookingRequestRepo();
      cubit = BookingRequestCubit(repository: repo);
      testCoach = const CoachProfileModel(
        uid: 'coach_123',
        name: 'Alex Coach',
        sports: ['Fitness', 'Boxing'],
        sessionPriceUSD: 50.0,
        monthlyPriceUSD: 250.0,
        workingDays: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday'],
        workingHours: {'from': '09:00', 'to': '17:00'},
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('init sets initial state with coach, dates, and loads slots', () async {
      cubit.init(testCoach);

      expect(cubit.state.coach, equals(testCoach));
      expect(cubit.state.selectedSport, 'Fitness');
      expect(cubit.state.bookingType, 'session');
      expect(cubit.state.availableDates.length, 30);
      expect(cubit.state.selectedDate, isNotNull);
    });

    test('selectBookingType toggles between session and monthly', () {
      cubit.init(testCoach);
      expect(cubit.state.isSession, isTrue);

      cubit.selectBookingType('monthly');
      expect(cubit.state.bookingType, 'monthly');
      expect(cubit.state.isMonthly, isTrue);
      expect(cubit.state.isSession, isFalse);

      cubit.selectBookingType('session');
      expect(cubit.state.isSession, isTrue);
    });

    test('totalPrice calculates session price and monthly package price', () {
      cubit.init(testCoach);
      expect(cubit.state.totalPrice, 50.0);

      cubit.selectBookingType('monthly');
      expect(cubit.state.totalPrice, 250.0);
    });

    test('isSubmitReady checks slot for session, but not for monthly', () {
      cubit.init(testCoach);
      // Session without slot selected
      expect(cubit.state.isSubmitReady, isFalse);

      cubit.selectSlot('11:00');
      expect(cubit.state.isSubmitReady, isTrue);

      // Monthly type does not require slot
      cubit.selectBookingType('monthly');
      cubit.selectSlot('');
      expect(cubit.state.isSubmitReady, isTrue);
    });

    test('submitBooking creates session booking with USD price and slot', () async {
      cubit.init(testCoach);
      cubit.selectSlot('14:00');
      cubit.updateNotes('Need form correction');

      await cubit.submitBooking();

      expect(cubit.state.status, BookingRequestStatus.success);
      expect(repo.lastCreatedBooking, isNotNull);
      final booking = repo.lastCreatedBooking!;
      expect(booking.bookingType, 'session');
      expect(booking.price, 50.0);
      expect(booking.currency, 'USD');
      expect(booking.startTime, '14:00');
      expect(booking.durationMonths, 1);
      expect(booking.monthlyScheduleNotes, isNull);
      expect(booking.notes, 'Need form correction');
    });

    test('submitBooking creates monthly booking with recurring preferences', () async {
      cubit.init(testCoach);
      cubit.selectBookingType('monthly');
      cubit.selectWeeklyFrequency(4);
      cubit.updateMonthlyScheduleNotes('Prefer evenings 6pm');
      cubit.updateNotes('Hypertrophy goal');

      await cubit.submitBooking();

      expect(cubit.state.status, BookingRequestStatus.success);
      expect(repo.lastCreatedBooking, isNotNull);
      final booking = repo.lastCreatedBooking!;
      expect(booking.bookingType, 'monthly');
      expect(booking.price, 250.0);
      expect(booking.currency, 'USD');
      expect(booking.startTime, 'Flexible');
      expect(booking.endTime, 'Flexible');
      expect(booking.durationMonths, 1);
      expect(booking.monthlyScheduleNotes, contains('4 days/week'));
      expect(booking.monthlyScheduleNotes, contains('Prefer evenings 6pm'));
      expect(booking.notes, 'Hypertrophy goal');
    });

    test('submitBooking handles error correctly', () async {
      repo.shouldFail = true;
      cubit.init(testCoach);
      cubit.selectSlot('12:00');

      await cubit.submitBooking();

      expect(cubit.state.status, BookingRequestStatus.error);
      expect(cubit.state.errorMessage, 'Network error');
    });
  });
}

