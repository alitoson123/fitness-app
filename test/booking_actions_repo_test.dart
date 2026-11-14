import 'package:fitness_app/features/booking_request/data/models/booking_model.dart';
import 'package:fitness_app/features/booking_request/data/models/booking_session_model.dart';
import 'package:fitness_app/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'helpers/fake_booking_store.dart';

const coachUid = 'coach_1';
const traineeUid = 'trainee_1';

BookingModel single({
  String status = 'pending',
  String? rescheduledBy,
  String? statusBeforeReschedule,
  String date = '2030-02-01',
}) =>
    BookingModel(
      id: 'b1',
      coachUid: coachUid,
      coachName: 'Sara',
      traineeUid: traineeUid,
      traineeName: 'Ali',
      sport: 'football',
      date: date,
      startTime: '10:00',
      endTime: '11:00',
      status: status,
      rescheduledBy: rescheduledBy,
      statusBeforeReschedule: statusBeforeReschedule,
      proposedDate: rescheduledBy == null ? null : '2030-02-05',
      proposedStartTime: rescheduledBy == null ? null : '12:00',
      proposedEndTime: rescheduledBy == null ? null : '13:00',
    );

BookingModel monthly({
  String status = 'confirmed',
  String? statusBeforeReschedule,
  List<BookingSessionModel>? sessions,
}) =>
    BookingModel(
      id: 'm1',
      coachUid: coachUid,
      coachName: 'Sara',
      traineeUid: traineeUid,
      traineeName: 'Ali',
      sport: 'football',
      bookingType: 'monthly',
      date: '2029-12-01',
      startTime: '10:00',
      endTime: '11:00',
      status: status,
      statusBeforeReschedule: statusBeforeReschedule,
      sessions: sessions ??
          const [
            BookingSessionModel(
                id: '1', date: '2029-12-01', startTime: '10:00', endTime: '11:00'),
            BookingSessionModel(
                id: '2', date: '2030-03-01', startTime: '10:00', endTime: '11:00'),
          ],
    );

void main() {
  setUpAll(() => S.load(const Locale('en')));

  late FakeBookingStore store;
  setUp(() => store = FakeBookingStore());

  group('single-session reschedule', () {
    test('propose records the earlier status and the REAL proposer', () async {
      store.put(single());
      final t = makeActionsRepo(store, uid: () => traineeUid);

      final r = await t.repo.proposeReschedule(
        bookingId: 'b1', date: '2030-02-05', startTime: '12:00', endTime: '13:00', reason: 'x',
      );

      expect(r.isRight(), isTrue);
      final b = store.booking('b1');
      expect(b.status, 'reschedule_pending');
      expect(b.statusBeforeReschedule, 'pending');
      expect(b.rescheduledBy, 'trainee');
      expect(t.sent.single.method, 'dispatchSingleRescheduleProposed');
      expect(t.sent.single['recipientUid'], coachUid);
    });

    test('coach declining a trainee proposal on an unapproved request -> pending (bug #1)', () async {
      store.put(single(status: 'reschedule_pending', rescheduledBy: 'trainee', statusBeforeReschedule: 'pending'));
      final c = makeActionsRepo(store, uid: () => coachUid);

      await c.repo.declineReschedule('b1');

      final b = store.booking('b1');
      expect(b.status, 'pending');
      expect(b.proposedDate, isNull);
      expect(b.rescheduledBy, isNull);
    });

    test('trainee declining the coach counter-offer on an unapproved request -> pending', () async {
      store.put(single(status: 'reschedule_pending', rescheduledBy: 'coach', statusBeforeReschedule: 'pending'));
      final t = makeActionsRepo(store, uid: () => traineeUid);

      await t.repo.declineReschedule('b1');

      expect(store.booking('b1').status, 'pending');
      // Notification goes FROM the trainee TO the coach (bug #3).
      expect(t.sent.single.method, 'dispatchSingleRescheduleDeclined');
      expect(t.sent.single['senderUid'], traineeUid);
      expect(t.sent.single['recipientUid'], coachUid);
    });

    test('declining on an approved booking keeps it confirmed (legacy docs too)', () async {
      store.put(single(status: 'reschedule_pending', rescheduledBy: 'trainee'));
      final c = makeActionsRepo(store, uid: () => coachUid);

      await c.repo.declineReschedule('b1');

      expect(store.booking('b1').status, 'confirmed');
    });

    test('accepting moves the booking to the proposed time and confirms it', () async {
      store.put(single(status: 'reschedule_pending', rescheduledBy: 'coach', statusBeforeReschedule: 'pending'));
      final t = makeActionsRepo(store, uid: () => traineeUid);

      await t.repo.acceptReschedule('b1');

      final b = store.booking('b1');
      expect(b.status, 'confirmed');
      expect(b.date, '2030-02-05');
      expect(b.startTime, '12:00');
      expect(b.previousDate, '2030-02-01');
      expect(t.sent.single['senderUid'], traineeUid);
    });

    test('nobody can answer their own proposal', () async {
      store.put(single(status: 'reschedule_pending', rescheduledBy: 'trainee', statusBeforeReschedule: 'pending'));
      final t = makeActionsRepo(store, uid: () => traineeUid);

      final r = await t.repo.acceptReschedule('b1');

      expect(r.isLeft(), isTrue);
      expect(store.writeCount, 0);
      expect(t.sent, isEmpty);
    });
  });

  group('access and errors', () {
    test('a user who is not on the booking is refused with a readable message', () async {
      store.put(single());
      final x = makeActionsRepo(store, uid: () => 'stranger');

      final r = await x.repo.approve('b1');

      expect(r.fold((f) => f.errorMessage, (_) => ''), S.current.bookingActionNotAllowed);
      expect(store.writeCount, 0);
    });

    test('missing booking -> "no longer exists"', () async {
      final c = makeActionsRepo(store, uid: () => coachUid);
      final r = await c.repo.approve('nope');
      expect(r.fold((f) => f.errorMessage, (_) => ''), S.current.bookingNotFoundMessage);
    });

    test('approving something already cancelled is refused, nothing written', () async {
      store.put(single(status: 'cancelled'));
      final c = makeActionsRepo(store, uid: () => coachUid);
      final r = await c.repo.approve('b1');
      expect(r.isLeft(), isTrue);
      expect(store.writeCount, 0);
    });
  });

  group('completing single bookings (#5)', () {
    test('not before the session time', () async {
      store.put(single(status: 'confirmed', date: '2030-02-01'));
      final c = makeActionsRepo(store, uid: () => coachUid, now: DateTime(2030, 2, 1, 9, 59));

      final r = await c.repo.completeBooking('b1');

      expect(r.fold((f) => f.errorMessage, (_) => ''), S.current.sessionNotStartedYet);
      expect(store.booking('b1').status, 'confirmed');
    });

    test('coach completes it once the time has come; trainee cannot', () async {
      store.put(single(status: 'confirmed', date: '2030-02-01'));
      final when = DateTime(2030, 2, 1, 10, 0);

      final t = makeActionsRepo(store, uid: () => traineeUid, now: when);
      expect((await t.repo.completeBooking('b1')).isLeft(), isTrue);

      final c = makeActionsRepo(store, uid: () => coachUid, now: when);
      expect((await c.repo.completeBooking('b1')).isRight(), isTrue);
      expect(store.booking('b1').status, 'completed');
      // The trainee is told, like for monthly sessions.
      expect(c.sent.map((n) => n.method), ['dispatchBookingCompleted']);
      expect(t.sent, isEmpty);
    });

    test('a pending (unapproved) booking cannot be completed', () async {
      store.put(single(status: 'pending', date: '2020-01-01'));
      final c = makeActionsRepo(store, uid: () => coachUid);
      expect((await c.repo.completeBooking('b1')).isLeft(), isTrue);
    });
  });

  group('trainee cancel', () {
    test('a request never approved can be withdrawn, even after its time', () async {
      store.put(single(status: 'pending', date: '2020-01-01'));
      final t = makeActionsRepo(store, uid: () => traineeUid);

      final r = await t.repo.cancel('b1', reason: '  changed plans ');

      expect(r.isRight(), isTrue);
      final b = store.booking('b1');
      expect(b.status, 'cancelled');
      expect(b.cancellationReason, 'changed plans');
      expect(t.sent.single.method, 'dispatchBookingCancelled');
    });

    test('an approved booking can be cancelled before it starts', () async {
      store.put(single(status: 'confirmed', date: '2030-02-01'));
      final t = makeActionsRepo(store, uid: () => traineeUid, now: DateTime(2030, 2, 1, 9, 59));
      expect((await t.repo.cancel('b1')).isRight(), isTrue);
      expect(store.booking('b1').status, 'cancelled');
    });

    test('not once it has started', () async {
      store.put(single(status: 'confirmed', date: '2030-02-01'));
      final t = makeActionsRepo(store, uid: () => traineeUid, now: DateTime(2030, 2, 1, 10, 0));

      final r = await t.repo.cancel('b1');

      expect(r.fold((f) => f.errorMessage, (_) => ''), S.current.bookingAlreadyStarted);
      expect(store.writeCount, 0);
    });

    test('approved monthly package: only before its first session', () async {
      store.put(monthly());
      final t = makeActionsRepo(store, uid: () => traineeUid, now: DateTime(2029, 12, 2));
      expect((await t.repo.cancel('m1')).isLeft(), isTrue);

      store.put(monthly());
      final early = makeActionsRepo(store, uid: () => traineeUid, now: DateTime(2029, 11, 30));
      expect((await early.repo.cancel('m1')).isRight(), isTrue);
    });

    test('the coach cannot use cancel, and finished bookings stay finished', () async {
      store.put(single(status: 'confirmed'));
      final c = makeActionsRepo(store, uid: () => coachUid);
      expect((await c.repo.cancel('b1')).isLeft(), isTrue);

      store.put(single(status: 'completed'));
      final t = makeActionsRepo(store, uid: () => traineeUid);
      expect((await t.repo.cancel('b1')).isLeft(), isTrue);
      expect(store.writeCount, 0);
    });
  });

  group('monthly sessions', () {
    test('proposing on an unapproved package remembers "pending"; answering restores it', () async {
      store.put(monthly(status: 'pending'));
      final c = makeActionsRepo(store, uid: () => coachUid);
      await c.repo.proposeSessionReschedule(
        bookingId: 'm1', sessionId: '2', date: '2030-03-02', startTime: '09:00', endTime: '10:00', reason: 'x',
      );
      var b = store.booking('m1');
      expect(b.status, 'reschedule_pending');
      expect(b.statusBeforeReschedule, 'pending');
      expect(b.getSessionById('2')!.rescheduledBy, 'coach');

      final t = makeActionsRepo(store, uid: () => traineeUid);
      await t.repo.declineSessionReschedule(bookingId: 'm1', sessionId: '2');

      b = store.booking('m1');
      expect(b.status, 'pending', reason: 'a decline must not approve the package');
      // The coach is told, and the notice comes from the trainee (bug #3).
      expect(t.sent.single.method, 'dispatchMonthlyRescheduleDeclined');
      expect(t.sent.single['senderUid'], traineeUid);
      expect(t.sent.single['recipientUid'], coachUid);
    });

    test('accepting on an approved package returns it to confirmed', () async {
      store.put(monthly());
      final t = makeActionsRepo(store, uid: () => traineeUid);
      await t.repo.proposeSessionReschedule(
        bookingId: 'm1', sessionId: '2', date: '2030-03-02', startTime: '09:00', endTime: '10:00', reason: 'x',
      );
      final c = makeActionsRepo(store, uid: () => coachUid);
      await c.repo.acceptSessionReschedule(bookingId: 'm1', sessionId: '2');

      final b = store.booking('m1');
      expect(b.status, 'confirmed');
      expect(b.getSessionById('2')!.date, '2030-03-02');
      expect(c.sent.single['senderUid'], coachUid);
    });

    test('completing: only approved packages, started sessions, no open proposal', () async {
      final now = DateTime(2030, 1, 1);

      store.put(monthly(status: 'pending'));
      var c = makeActionsRepo(store, uid: () => coachUid, now: now);
      expect((await c.repo.completeSession(bookingId: 'm1', sessionId: '1')).isLeft(), isTrue,
          reason: 'package not approved');

      store.put(monthly());
      c = makeActionsRepo(store, uid: () => coachUid, now: now);
      final future = await c.repo.completeSession(bookingId: 'm1', sessionId: '2');
      expect(future.fold((f) => f.errorMessage, (_) => ''), S.current.sessionNotStartedYet);

      final ok = await c.repo.completeSession(bookingId: 'm1', sessionId: '1');
      expect(ok.isRight(), isTrue);
      expect(store.booking('m1').getSessionById('1')!.isCompleted, isTrue);
      // Count is right: 1 of 2 (it used to say 2 of 2).
      expect(c.sent.single['completedCount'], 1);
      expect(c.sent.single['totalCount'], 2);
    });

    test('a session waiting for a reschedule answer cannot be completed', () async {
      store.put(monthly(
        status: 'reschedule_pending',
        statusBeforeReschedule: 'confirmed',
        sessions: const [
          BookingSessionModel(
            id: '1', date: '2029-12-01', startTime: '10:00', endTime: '11:00',
            status: 'reschedule_pending', rescheduledBy: 'coach',
          ),
        ],
      ));
      final c = makeActionsRepo(store, uid: () => coachUid);
      expect((await c.repo.completeSession(bookingId: 'm1', sessionId: '1')).isLeft(), isTrue);
    });

    test('changes always build on the stored booking, not a stale screen copy', () async {
      // Two different people change two different sessions one after the
      // other: both changes must survive (the old code could drop one).
      store.put(monthly(sessions: const [
        BookingSessionModel(id: '1', date: '2029-12-01', startTime: '10:00', endTime: '11:00'),
        BookingSessionModel(id: '2', date: '2030-03-01', startTime: '10:00', endTime: '11:00'),
      ]));
      final c = makeActionsRepo(store, uid: () => coachUid);
      final t = makeActionsRepo(store, uid: () => traineeUid);

      await c.repo.completeSession(bookingId: 'm1', sessionId: '1');
      await t.repo.proposeSessionReschedule(
        bookingId: 'm1', sessionId: '2', date: '2030-03-02', startTime: '09:00', endTime: '10:00', reason: 'x',
      );

      final b = store.booking('m1');
      expect(b.getSessionById('1')!.isCompleted, isTrue);
      expect(b.getSessionById('2')!.isReschedulePending, isTrue);
    });
  });
}
