import 'dart:async';
import 'package:fitness_app/features/booking_details/data/data_source/booking_details_remote_data_source.dart';
import 'package:fitness_app/features/booking_details/data/repos/booking_details_repo.dart';
import 'package:fitness_app/features/booking_details/presentation/view_model/booking_details_cubit/booking_details_cubit.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/fake_booking_store.dart';

class _FakeRemoteDataSource implements BookingDetailsRemoteDataSource {
  final _controller = StreamController<BookingModel>.broadcast();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<BookingModel> streamBooking(String bookingId) => _controller.stream;

  void dispose() => _controller.close();
}

void main() {
  setUpAll(() => S.load(const Locale('en')));

  late FakeBookingStore store;
  late _FakeRemoteDataSource fakeRemote;
  late BookingDetailsCubit cubit;
  // Who is using the screen in a test.
  late String actingUid;

  const monthlyBooking = BookingModel(
    id: 'b_1',
    coachUid: 'coach_1',
    coachName: 'Coach John',
    traineeUid: 'trainee_1',
    traineeName: 'Ali Trainee',
    sport: 'Football',
    bookingType: 'monthly',
    date: '2029-12-31',
    startTime: '10:00',
    endTime: '11:00',
    price: 300.0,
    currency: 'USD',
    status: 'pending',
    sessions: [
      BookingSessionModel(
        id: 's_1',
        date: '2029-12-31',
        startTime: '10:00',
        endTime: '11:00',
        status: 'scheduled',
      ),
      BookingSessionModel(
        id: 's_2',
        date: '2030-02-01',
        startTime: '10:00',
        endTime: '11:00',
        status: 'scheduled',
      ),
    ],
  );

  const singleBooking = BookingModel(
    id: 'b_2',
    coachUid: 'coach_1',
    traineeUid: 'trainee_1',
    sport: 'Football',
    date: '2030-11-01',
    startTime: '10:00',
    endTime: '11:00',
    status: 'confirmed',
  );

  setUp(() {
    actingUid = 'coach_1';
    store = FakeBookingStore();
    fakeRemote = _FakeRemoteDataSource();
    final actions = makeActionsRepo(store, uid: () => actingUid).repo;
    cubit = BookingDetailsCubit(
      repository: BookingDetailsRepo(remoteDataSource: fakeRemote, actions: actions),
    );
  });

  tearDown(() {
    cubit.close();
    fakeRemote.dispose();
  });

  test('init sets initial booking and listens to updates', () async {
    cubit.init(monthlyBooking);
    expect(cubit.state.booking?.id, 'b_1');
    expect(cubit.state.booking?.traineeName, 'Ali Trainee');
  });

  test('acceptBooking triggers update and sets successMessage', () async {
    store.put(monthlyBooking);
    cubit.init(monthlyBooking);
    await cubit.acceptBooking();

    expect(cubit.state.successMessage, 'accepted');
    expect(cubit.state.isActionInProgress, false);
    expect(store.booking('b_1').status, 'confirmed');
  });

  test('rejectBooking updates status to rejected with reason', () async {
    store.put(monthlyBooking);
    cubit.init(monthlyBooking);
    await cubit.rejectBooking(reason: 'Fully booked');

    expect(cubit.state.successMessage, 'rejected');
    expect(store.booking('b_1').status, 'rejected');
    expect(store.booking('b_1').rejectionReason, 'Fully booked');
  });

  test('markSessionCompleted updates session status on an approved package', () async {
    final approved = monthlyBooking.copyWith(status: 'confirmed');
    store.put(approved);
    cubit.init(approved);
    await cubit.markSessionCompleted('s_1');

    expect(cubit.state.successMessage, 'session_completed');
    expect(store.booking('b_1').sessions.first.isCompleted, true);
  });

  test('markSessionCompleted is refused on a package not approved yet', () async {
    store.put(monthlyBooking);
    cubit.init(monthlyBooking);
    await cubit.markSessionCompleted('s_1');

    expect(cubit.state.errorMessage, S.current.bookingActionNotAllowed);
    expect(store.booking('b_1').sessions.first.isCompleted, false);
  });

  test('requestReschedule updates booking with proposed time', () async {
    store.put(singleBooking);
    cubit.init(singleBooking);
    await cubit.requestReschedule(
      proposedDate: '2030-11-05',
      proposedStartTime: '14:00',
      proposedEndTime: '15:00',
      reason: 'Schedule conflict',
    );

    expect(cubit.state.successMessage, 'rescheduled');
    expect(store.booking('b_2').status, 'reschedule_pending');
    expect(store.booking('b_2').rescheduledBy, 'coach');
  });

  test('acceptReschedule confirms proposed time', () async {
    final proposed = singleBooking.copyWith(
      status: 'reschedule_pending',
      rescheduledBy: 'trainee',
      proposedDate: '2030-11-05',
      proposedStartTime: '14:00',
      proposedEndTime: '15:00',
    );
    store.put(proposed);
    cubit.init(proposed);
    await cubit.acceptReschedule();

    expect(cubit.state.successMessage, 'reschedule_accepted');
    expect(store.booking('b_2').status, 'confirmed');
    expect(store.booking('b_2').date, '2030-11-05');
  });

  test('declineReschedule declines with reason', () async {
    final proposed = singleBooking.copyWith(
      status: 'reschedule_pending',
      rescheduledBy: 'coach',
      proposedDate: '2030-11-05',
      proposedStartTime: '14:00',
    );
    actingUid = 'trainee_1';
    store.put(proposed);
    cubit.init(proposed);
    await cubit.declineReschedule(reason: 'Cannot attend');

    expect(cubit.state.successMessage, 'reschedule_declined');
    expect(store.booking('b_2').status, 'confirmed');
  });

  test('completeBooking marks a past single session completed', () async {
    final past = singleBooking.copyWith(date: '2020-01-01');
    store.put(past);
    cubit.init(past);
    await cubit.completeBooking();

    expect(cubit.state.successMessage, 'booking_completed');
    expect(store.booking('b_2').status, 'completed');
  });
}
