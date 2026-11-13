import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/booking_request/data/data_source/booking_request_remote_data_source.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/features/booking_request/data/models/busy_range.dart';
import 'package:fitness_app/features/booking_request/data/repos/booking_actions/booking_transitions.dart';
import 'package:fitness_app/features/booking_request/data/repos/booking_request_repo.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_builder_helper.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_request_cubit.dart';
import 'package:fitness_app/features/booking_request/presentation/view_model/booking_request_cubit/booking_slot_calculator.dart';
import 'package:fitness_app/features/coach_dashboard/presentation/view_model/coach_bookings_cubit/coach_bookings_states.dart';
import 'package:fitness_app/features/coach_setup/data/models/coach_profile_model.dart';
import 'package:fitness_app/features/trainee_bookings/presentation/view_model/trainee_bookings_cubit/trainee_bookings_states.dart';
import 'package:fitness_app/features/trainee_setup/data/models/trainee_profile_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/fake_booking_store.dart';

class _NoAuth implements AuthService {
  @override
  User? get currentUser => null;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Each day's busy times arrive when the test decides (or fail).
class _ControlledRepo implements BookingRequestRepo {
  final pending = <String, Completer<Either<Failure, List<BusyRange>>>>{};
  int loads = 0;
  Either<Failure, String> createResult = const Right('id');

  @override
  AuthService get authService => _NoAuth();

  @override
  Future<Either<Failure, List<BusyRange>>> getBusyRanges({
    required String coachUid,
    required String date,
    int sessionDurationMinutes = 60,
  }) {
    loads++;
    return (pending[date] = Completer()).future;
  }

  @override
  Future<TraineeProfileModel?> getCurrentTrainee() async =>
      const TraineeProfileModel(uid: 't', name: 'T');

  @override
  Future<Either<Failure, String>> createBooking(BookingModel booking) async =>
      createResult;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _coach = CoachProfileModel(
  uid: 'coach1',
  name: 'Sara',
  sports: ['football'],
  sessionPriceUSD: 50,
  monthlyPriceUSD: 300,
  sessionDurationMinutes: 60,
);

DateTime _day(int offset) {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day + offset);
}

void main() {
  setUpAll(() => S.load(const Locale('en')));

  group('free times use overlaps, not equal start times (#3)', () {
    final coach45 = _coach.copyWith(sessionDurationMinutes: 45);
    final future = DateTime(2030, 3, 2);

    test('a 60-minute booking hides every 45-minute slot it touches', () {
      final slots = BookingSlotCalculator.generateDaySlots(
        coach: coach45,
        date: future,
        busyRanges: const [BusyRange(18 * 60, 19 * 60)],
        now: DateTime(2030, 3, 1),
      );
      // 17:45-18:30 and 18:30-19:15 overlap 18:00-19:00.
      expect(slots, ['17:00', '19:15', '20:00']);
    });

    test('back-to-back is free', () {
      final slots = BookingSlotCalculator.generateDaySlots(
        coach: coach45,
        date: future,
        busyRanges: const [BusyRange(17 * 60, 17 * 60 + 45)],
        now: DateTime(2030, 3, 1),
      );
      expect(slots.first, '17:45');
    });
  });

  group('booking screen', () {
    late _ControlledRepo repo;
    late BookingRequestCubit cubit;

    setUp(() {
      repo = _ControlledRepo();
      cubit = BookingRequestCubit(repository: repo)..init(_coach);
    });
    tearDown(() => cubit.close());

    String key(DateTime d) => BookingBuilderHelper.formatDate(d);

    test('a late answer for an old day does not overwrite the new day (#5)', () async {
      final a = _day(2), b = _day(3);
      cubit.loadSlotsForDate(a);
      cubit.loadSlotsForDate(b);

      repo.pending[key(b)]!.complete(const Right([]));
      await Future<void>.delayed(Duration.zero);
      final slotsForB = cubit.state.availableSlots;

      // Day A's answer arrives last: everything busy on A.
      repo.pending[key(a)]!.complete(const Right([BusyRange(0, 1440)]));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.selectedDate, b);
      expect(cubit.state.availableSlots, slotsForB);
      expect(slotsForB, isNotEmpty);
    });

    test('a failed load shows Retry instead of "no times" (#6)', () async {
      final d = _day(2);
      cubit.loadSlotsForDate(d);
      repo.pending[key(d)]!.complete(Left(ServerFailure(errorMessage: 'x')));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.slotsLoadFailed, isTrue);

      cubit.retryLoadingSlots();
      expect(cubit.state.slotsLoadFailed, isFalse);
      repo.pending[key(d)]!.complete(const Right([]));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state.slotsLoadFailed, isFalse);
      expect(cubit.state.availableSlots, isNotEmpty);
    });

    test('slot taken: the clashing monthly session is dropped and times reload (#1)', () async {
      cubit.selectBookingType('monthly');
      for (var i = 1; i <= 8; i++) {
        cubit.toggleMonthlySession(_day(i), '18:00');
      }
      expect(cubit.state.isMonthlyComplete, isTrue);
      final clash = key(_day(3));
      repo.createResult = Left(BookingRequestFailure(
        reason: 'slot_taken',
        errorMessage: 'taken',
        conflictDate: clash,
        conflictStartTime: '18:00',
      ));
      final loadsBefore = repo.loads;

      await cubit.submitBooking();

      expect(cubit.state.selectedMonthlySessions.length, 7);
      expect(cubit.state.selectedMonthlySessions.any((s) => s.date == clash), isFalse);
      expect(repo.loads, loadsBefore + 1, reason: 'fresh times are loaded');
    });

    test('monthly cannot be picked when the coach has no monthly price (#8)', () {
      final c = BookingRequestCubit(repository: repo)
        ..init(_coach.copyWith(monthlyPriceUSD: 0));
      c.selectBookingType('monthly');
      expect(c.state.bookingType, 'session');
      c.close();
    });
  });

  test('server refusals become readable messages', () {
    expect(
      BookingRequestRepo.messageFor(const BookingRequestException('too_many_requests')),
      contains('3'),
    );
    expect(
      BookingRequestRepo.messageFor(const BookingRequestException('slot_taken',
          conflictDate: '2030-03-02', conflictStartTime: '18:00')),
      S.current.bookingSlotTaken,
    );
    expect(
      BookingRequestRepo.messageFor(
        const BookingRequestException('slot_taken',
            conflictDate: '2030-03-02', conflictStartTime: '18:00'),
        isMonthly: true,
      ),
      contains('2030-03-02'),
    );
    expect(
      BookingRequestRepo.messageFor(const BookingRequestException('weird')),
      S.current.unexpectedErrorMessage,
    );
  });

  group('expired requests (#4)', () {
    const request = BookingModel(
      id: 'b1',
      coachUid: 'coach_1',
      traineeUid: 'trainee_1',
      sport: 'football',
      date: '2030-02-01',
      startTime: '10:00',
      endTime: '11:00',
      status: 'pending',
    );
    final after = DateTime(2030, 2, 1, 10, 0);
    final before = DateTime(2030, 2, 1, 9, 0);

    test('a pending request whose time passed is expired; approved ones never are', () {
      expect(BookingTransitions.isExpired(request, before), isFalse);
      expect(BookingTransitions.isExpired(request, after), isTrue);
      expect(BookingTransitions.displayStatus(request, after), 'expired');
      expect(BookingTransitions.isExpired(request.copyWith(status: 'confirmed'), after), isFalse);
    });

    test('an open counter-offer in the future keeps it alive', () {
      final countered = request.copyWith(
        status: 'reschedule_pending',
        statusBeforeReschedule: 'pending',
        rescheduledBy: 'coach',
        proposedDate: '2030-02-05',
        proposedStartTime: '10:00',
      );
      expect(BookingTransitions.isExpired(countered, after), isFalse);
      expect(BookingTransitions.isExpired(countered, DateTime(2030, 2, 6)), isTrue);
    });

    test('the coach can no longer approve it', () async {
      final store = FakeBookingStore()..put(request);
      final c = makeActionsRepo(store, uid: () => 'coach_1', now: after);

      final r = await c.repo.approve('b1');

      expect(r.fold((f) => f.errorMessage, (_) => ''), S.current.requestExpiredMessage);
      expect(store.writeCount, 0);
    });

    test('nobody can move a booking to a time that has passed', () async {
      final store = FakeBookingStore()..put(request.copyWith(status: 'confirmed'));
      final t = makeActionsRepo(store, uid: () => 'trainee_1', now: before);

      final r = await t.repo.proposeReschedule(
        bookingId: 'b1', date: '2030-01-31', startTime: '10:00', endTime: '11:00', reason: 'xxxxx',
      );

      expect(r.fold((f) => f.errorMessage, (_) => ''), S.current.bookingTimeInPast);
    });

    test('expired requests move to the history tabs', () {
      final old = request.copyWith(id: 'old', date: '2020-01-01');
      final fresh = request.copyWith(id: 'new', date: '2099-01-01');

      final coach = CoachBookingsState(allBookings: [old, fresh]);
      expect(coach.pendingBookings.map((b) => b.id), ['new']);
      expect(coach.pastBookings.map((b) => b.id), ['old']);

      final trainee = TraineeBookingsState(allBookings: [old, fresh]);
      expect(trainee.activeBookings.map((b) => b.id), ['new']);
      expect(trainee.historyBookings.map((b) => b.id), ['old']);
    });

    test('monthly: expired only once every session (and proposal) has passed', () {
      const pkg = BookingModel(
        id: 'm',
        coachUid: 'c',
        traineeUid: 't',
        sport: 'football',
        bookingType: 'monthly',
        date: '2030-02-01',
        startTime: '10:00',
        endTime: '11:00',
        status: 'pending',
        sessions: [
          BookingSessionModel(id: '1', date: '2030-02-01', startTime: '10:00', endTime: '11:00'),
          BookingSessionModel(id: '2', date: '2030-02-20', startTime: '10:00', endTime: '11:00'),
        ],
      );
      expect(BookingTransitions.isExpired(pkg, DateTime(2030, 2, 10)), isFalse);
      expect(BookingTransitions.isExpired(pkg, DateTime(2030, 2, 21)), isTrue);
    });
  });
}
