import 'dart:async';
import 'package:fitness_app/features/booking_details/data/data_source/booking_details_remote_data_source.dart';
import 'package:fitness_app/features/booking_details/data/repos/booking_details_repo.dart';
import 'package:fitness_app/features/booking_details/presentation/view_model/booking_details_cubit/booking_details_cubit.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteDataSource implements BookingDetailsRemoteDataSource {
  final _controller = StreamController<BookingModel>.broadcast();
  BookingModel? currentBooking;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Stream<BookingModel> streamBooking(String bookingId) => _controller.stream;

  @override
  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
    String? rejectionReason,
  }) async {
    currentBooking = currentBooking?.copyWith(
      status: status,
      rejectionReason: rejectionReason,
    );
  }

  @override
  Future<void> markSessionCompleted({
    required String bookingId,
    required String sessionId,
  }) async {
    final sessions = currentBooking?.sessions.map((s) {
      if (s.id == sessionId) return s.copyWith(status: 'completed');
      return s;
    }).toList();
    if (sessions != null) {
      currentBooking = currentBooking?.copyWith(sessions: sessions);
    }
  }

  @override
  Future<void> requestReschedule({
    required BookingModel booking,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) async {
    currentBooking = currentBooking?.copyWith(
      status: 'reschedule_pending',
      proposedDate: proposedDate,
      proposedStartTime: proposedStartTime,
      proposedEndTime: proposedEndTime,
      rescheduleReason: reason,
      rescheduledBy: rescheduledBy,
    );
  }

  @override
  Future<void> acceptReschedule({required BookingModel booking}) async {
    currentBooking = currentBooking?.copyWith(
      status: 'confirmed',
      date: booking.proposedDate,
      startTime: booking.proposedStartTime,
      endTime: booking.proposedEndTime,
    );
  }

  @override
  Future<void> declineReschedule({
    required String bookingId,
    String? declineReason,
  }) async {
    currentBooking = currentBooking?.copyWith(
      status: 'confirmed',
      rejectionReason: declineReason,
    );
  }

  void dispose() => _controller.close();
}

void main() {
  late _FakeRemoteDataSource fakeRemote;
  late BookingDetailsRepo repo;
  late BookingDetailsCubit cubit;

  final sampleBooking = BookingModel(
    id: 'b_1',
    coachUid: 'coach_1',
    coachName: 'Coach John',
    traineeUid: 'trainee_1',
    traineeName: 'Ali Trainee',
    sport: 'Football',
    bookingType: 'monthly',
    date: '2026-11-01',
    startTime: '10:00',
    endTime: '11:00',
    price: 300.0,
    currency: 'USD',
    sessions: const [
      BookingSessionModel(
        id: 's_1',
        date: '2026-11-01',
        startTime: '10:00',
        endTime: '11:00',
        status: 'scheduled',
      ),
      BookingSessionModel(
        id: 's_2',
        date: '2026-11-08',
        startTime: '10:00',
        endTime: '11:00',
        status: 'scheduled',
      ),
    ],
  );

  setUp(() {
    fakeRemote = _FakeRemoteDataSource()..currentBooking = sampleBooking;
    repo = BookingDetailsRepo(remoteDataSource: fakeRemote);
    cubit = BookingDetailsCubit(repository: repo);
  });

  tearDown(() {
    cubit.close();
    fakeRemote.dispose();
  });

  test('init sets initial booking and listens to updates', () async {
    cubit.init(sampleBooking);
    expect(cubit.state.booking?.id, 'b_1');
    expect(cubit.state.booking?.traineeName, 'Ali Trainee');
  });

  test('acceptBooking triggers update and sets successMessage', () async {
    cubit.init(sampleBooking);
    await cubit.acceptBooking();

    expect(cubit.state.successMessage, 'accepted');
    expect(cubit.state.isActionInProgress, false);
    expect(fakeRemote.currentBooking?.status, 'confirmed');
  });

  test('rejectBooking updates status to rejected with reason', () async {
    cubit.init(sampleBooking);
    await cubit.rejectBooking(reason: 'Fully booked');

    expect(cubit.state.successMessage, 'rejected');
    expect(fakeRemote.currentBooking?.status, 'rejected');
    expect(fakeRemote.currentBooking?.rejectionReason, 'Fully booked');
  });

  test('markSessionCompleted updates session status', () async {
    cubit.init(sampleBooking);
    await cubit.markSessionCompleted('s_1');

    expect(cubit.state.successMessage, 'session_completed');
    expect(fakeRemote.currentBooking?.sessions.first.isCompleted, true);
  });

  test('requestReschedule updates booking with proposed time', () async {
    cubit.init(sampleBooking);
    await cubit.requestReschedule(
      proposedDate: '2026-11-05',
      proposedStartTime: '14:00',
      proposedEndTime: '15:00',
      reason: 'Schedule conflict',
      rescheduledBy: 'coach',
    );

    expect(cubit.state.successMessage, 'rescheduled');
    expect(fakeRemote.currentBooking?.status, 'reschedule_pending');
  });

  test('acceptReschedule confirms proposed time', () async {
    final rescheduleBooking = sampleBooking.copyWith(
      status: 'reschedule_pending',
      proposedDate: '2026-11-05',
      proposedStartTime: '14:00',
      proposedEndTime: '15:00',
    );
    cubit.init(rescheduleBooking);
    await cubit.acceptReschedule();

    expect(cubit.state.successMessage, 'reschedule_accepted');
    expect(fakeRemote.currentBooking?.status, 'confirmed');
  });

  test('declineReschedule declines with reason', () async {
    final rescheduleBooking = sampleBooking.copyWith(
      status: 'reschedule_pending',
    );
    cubit.init(rescheduleBooking);
    await cubit.declineReschedule(reason: 'Cannot attend');

    expect(cubit.state.successMessage, 'reschedule_declined');
  });
}

