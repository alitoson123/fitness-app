import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/database_service/firestore_service.dart';
import '../../../../../core/services/logger_service/logger_service.dart';
import '../../../../../generated/l10n.dart';
import '../../../../notifications/data/helpers/notification_dispatcher.dart';
import '../../../../notifications/data/helpers/notification_safe_dispatcher.dart';
import '../../models/booking_model.dart';
import 'booking_transitions.dart';

typedef NotificationSender = void Function(
  Future<void> Function(NotificationDispatcher dispatcher) action,
);

/// The one place that changes existing bookings. The coach dashboard, the
/// trainee bookings tab and the shared Booking Details screen all use it,
/// so the rules, notifications and error messages can't drift apart again.
///
/// Every action:
/// 1. works out whether the signed-in user is the booking's coach or trainee,
/// 2. re-reads the booking inside a transaction and validates the action on
///    that fresh copy ([BookingTransitions]), so concurrent edits can't be
///    lost or applied to a stale state,
/// 3. notifies the other participant, built from the booking as it was
///    before the change (so "who proposed" is still known).
class BookingActionsRepo {
  final FirestoreService firestoreService;
  final String? Function() currentUid;
  final DateTime Function() _now;
  final NotificationSender _notify;

  BookingActionsRepo({
    required this.firestoreService,
    required this.currentUid,
    DateTime Function()? clock,
    NotificationSender? notify,
  })  : _now = clock ?? DateTime.now,
        _notify = notify ?? NotificationSafeDispatcher.dispatch;

  // ----------------------------------------------------------- whole booking

  Future<Either<Failure, void>> approve(String bookingId) => _run(
        bookingId,
        BookingTransitions.approve,
        (before, _) => _notify((d) => d.dispatchBookingApproved(
              booking: before,
              coachName: _coachName(before),
            )),
      );

  Future<Either<Failure, void>> reject(String bookingId, {String? reason}) =>
      _run(
        bookingId,
        (b, actor) => BookingTransitions.reject(b, actor, reason: reason),
        (before, _) => _notify((d) => d.dispatchBookingRejected(
              booking: before,
              coachName: _coachName(before),
              reason: (reason?.trim().isNotEmpty ?? false)
                  ? reason!.trim()
                  : 'Unavailable',
            )),
      );

  Future<Either<Failure, void>> cancel(String bookingId, {String? reason}) =>
      _run(
        bookingId,
        (b, actor) =>
            BookingTransitions.cancel(b, actor, reason: reason, now: _now()),
        (before, _) => _notify((d) => d.dispatchBookingCancelled(
              booking: before,
              traineeName: _traineeName(before),
            )),
      );

  Future<Either<Failure, void>> completeBooking(String bookingId) => _run(
        bookingId,
        (b, actor) =>
            BookingTransitions.completeBooking(b, actor, now: _now()),
        null,
      );

  // ------------------------------------------------- single-session reschedule

  Future<Either<Failure, void>> proposeReschedule({
    required String bookingId,
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
  }) =>
      _run(
        bookingId,
        (b, actor) => BookingTransitions.proposeReschedule(
          b,
          actor,
          date: date,
          startTime: startTime,
          endTime: endTime,
          reason: reason,
        ),
        (before, actor) {
          final p = _parties(before, actor);
          _notify((d) => d.dispatchSingleRescheduleProposed(
                booking: before,
                senderUid: p.senderUid,
                senderName: p.senderName,
                recipientUid: p.recipientUid,
                recipientRole: p.recipientRole,
                proposedDate: date,
                proposedTime: startTime,
                reason: reason,
              ));
        },
      );

  Future<Either<Failure, void>> acceptReschedule(String bookingId) => _run(
        bookingId,
        BookingTransitions.acceptReschedule,
        (before, actor) {
          final p = _parties(before, actor);
          _notify((d) => d.dispatchSingleRescheduleAccepted(
                booking: before,
                senderUid: p.senderUid,
                senderName: p.senderName,
                recipientUid: p.recipientUid,
                recipientRole: p.recipientRole,
                date: before.proposedDate ?? before.date,
              ));
        },
      );

  Future<Either<Failure, void>> declineReschedule(
    String bookingId, {
    String? reason,
  }) =>
      _run(
        bookingId,
        (b, actor) =>
            BookingTransitions.declineReschedule(b, actor, reason: reason),
        (before, actor) {
          final p = _parties(before, actor);
          _notify((d) => d.dispatchSingleRescheduleDeclined(
                booking: before,
                senderUid: p.senderUid,
                senderName: p.senderName,
                recipientUid: p.recipientUid,
                recipientRole: p.recipientRole,
              ));
        },
      );

  // -------------------------------------------------------- monthly sessions

  Future<Either<Failure, void>> proposeSessionReschedule({
    required String bookingId,
    required String sessionId,
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
  }) =>
      _run(
        bookingId,
        (b, actor) => BookingTransitions.proposeSessionReschedule(
          b,
          actor,
          sessionId: sessionId,
          date: date,
          startTime: startTime,
          endTime: endTime,
          reason: reason,
        ),
        (before, actor) {
          final p = _parties(before, actor);
          _notify((d) => d.dispatchMonthlyRescheduleProposed(
                booking: before,
                sessionNumber: _sessionNumber(before, sessionId),
                sessionId: sessionId,
                senderUid: p.senderUid,
                senderName: p.senderName,
                recipientUid: p.recipientUid,
                recipientRole: p.recipientRole,
                proposedDate: date,
                proposedTime: startTime,
              ));
        },
      );

  Future<Either<Failure, void>> acceptSessionReschedule({
    required String bookingId,
    required String sessionId,
  }) =>
      _run(
        bookingId,
        (b, actor) => BookingTransitions.acceptSessionReschedule(
          b,
          actor,
          sessionId: sessionId,
        ),
        (before, actor) {
          final p = _parties(before, actor);
          _notify((d) => d.dispatchMonthlyRescheduleAccepted(
                booking: before,
                sessionNumber: _sessionNumber(before, sessionId),
                sessionId: sessionId,
                senderUid: p.senderUid,
                senderName: p.senderName,
                recipientUid: p.recipientUid,
                recipientRole: p.recipientRole,
              ));
        },
      );

  Future<Either<Failure, void>> declineSessionReschedule({
    required String bookingId,
    required String sessionId,
  }) =>
      _run(
        bookingId,
        (b, actor) => BookingTransitions.declineSessionReschedule(
          b,
          actor,
          sessionId: sessionId,
        ),
        (before, actor) {
          final p = _parties(before, actor);
          _notify((d) => d.dispatchMonthlyRescheduleDeclined(
                booking: before,
                sessionNumber: _sessionNumber(before, sessionId),
                sessionId: sessionId,
                senderUid: p.senderUid,
                senderName: p.senderName,
                recipientUid: p.recipientUid,
                recipientRole: p.recipientRole,
              ));
        },
      );

  Future<Either<Failure, void>> completeSession({
    required String bookingId,
    required String sessionId,
  }) =>
      _run(
        bookingId,
        (b, actor) => BookingTransitions.completeSession(
          b,
          actor,
          sessionId: sessionId,
          now: _now(),
        ),
        (before, _) => _notify((d) => d.dispatchMonthlySessionCompleted(
              booking: before,
              sessionNumber: _sessionNumber(before, sessionId),
              sessionId: sessionId,
              // `before` doesn't include this session yet, hence + 1.
              completedCount: before.completedSessionsCount + 1,
              totalCount: before.sessions.length,
            )),
      );

  // ------------------------------------------------------------------ engine

  Future<Either<Failure, void>> _run(
    String bookingId,
    Map<String, dynamic> Function(BookingModel booking, String actor) build,
    void Function(BookingModel before, String actor)? onSuccess,
  ) async {
    final uid = currentUid();
    String? actor;
    BookingModel? before;
    try {
      await firestoreService.transactUpdate(
        collection: AppConstants.bookingsCollection,
        docId: bookingId,
        buildUpdate: (data) {
          if (data == null) {
            throw const BookingActionException(BookingActionError.notFound);
          }
          final b = BookingModel.fromJson(data, id: bookingId);
          final role = uid == null
              ? null
              : b.coachUid == uid
                  ? AppConstants.roleCoach
                  : b.traineeUid == uid
                      ? AppConstants.roleTrainee
                      : null;
          if (role == null) {
            throw const BookingActionException(BookingActionError.notAllowed);
          }
          actor = role;
          before = b;
          return build(b, role);
        },
      );
    } on BookingActionException catch (e) {
      LoggerService.warning('Booking action refused: ${e.error}',
          tag: 'BookingActionsRepo');
      return Left(ServerFailure(errorMessage: messageFor(e.error)));
    } on FirebaseException catch (e) {
      LoggerService.error('Booking action failed: ${e.code}',
          tag: 'BookingActionsRepo', error: e);
      return Left(ServerFailure(errorMessage: _firebaseMessage(e)));
    } catch (e, st) {
      LoggerService.error('Booking action failed: $e',
          tag: 'BookingActionsRepo', error: e, stackTrace: st);
      return Left(ServerFailure(errorMessage: S.current.unexpectedErrorMessage));
    }

    onSuccess?.call(before!, actor!);
    return const Right(null);
  }

  static String messageFor(BookingActionError error) {
    final s = S.current;
    switch (error) {
      case BookingActionError.notFound:
        return s.bookingNotFoundMessage;
      case BookingActionError.notAllowed:
        return s.bookingActionNotAllowed;
      case BookingActionError.notStartedYet:
        return s.sessionNotStartedYet;
      case BookingActionError.alreadyStarted:
        return s.bookingAlreadyStarted;
    }
  }

  static String _firebaseMessage(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
      case 'failed-precondition':
      case 'aborted':
        return S.current.bookingActionNotAllowed;
      case 'not-found':
        return S.current.bookingNotFoundMessage;
      case 'unavailable':
      case 'deadline-exceeded':
      case 'network-request-failed':
        return S.current.connectionErrorMessage;
      default:
        return S.current.unexpectedErrorMessage;
    }
  }

  // ------------------------------------------------------------------ helpers

  static String _coachName(BookingModel b) =>
      b.coachName.isNotEmpty ? b.coachName : 'Coach';

  static String _traineeName(BookingModel b) =>
      b.traineeName.isNotEmpty ? b.traineeName : 'Trainee';

  static int _sessionNumber(BookingModel b, String sessionId) {
    final i = b.sessions.indexWhere((s) => s.id == sessionId);
    if (i < 0) return 1;
    return int.tryParse(b.sessions[i].id) ?? i + 1;
  }

  static ({
    String senderUid,
    String senderName,
    String recipientUid,
    String recipientRole,
  }) _parties(BookingModel b, String actor) {
    final isCoach = actor == AppConstants.roleCoach;
    return (
      senderUid: isCoach ? b.coachUid : b.traineeUid,
      senderName: isCoach ? _coachName(b) : _traineeName(b),
      recipientUid: isCoach ? b.traineeUid : b.coachUid,
      recipientRole: isCoach ? AppConstants.roleTrainee : AppConstants.roleCoach,
    );
  }
}
