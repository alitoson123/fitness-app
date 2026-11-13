import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../models/booking_model.dart';
import '../../models/booking_session_model.dart';

/// Why a booking action was refused before anything was written.
enum BookingActionError {
  /// The booking no longer exists.
  notFound,

  /// The booking/session is not in a state where this person may do this
  /// (e.g. already cancelled, or responding to your own proposal).
  notAllowed,

  /// "Mark as completed" before the session time.
  notStartedYet,

  /// Cancelling an approved booking whose (first) session already started.
  alreadyStarted,

  /// The coach never answered and the request's time has passed.
  expired,

  /// Moving a booking to a time that has already passed.
  timeInPast,
}

class BookingActionException implements Exception {
  final BookingActionError error;
  const BookingActionException(this.error);

  @override
  String toString() => 'BookingActionException($error)';
}

/// Pure rules for every booking action. Each method checks that the action
/// is valid for [b] and the acting role, then returns the Firestore fields
/// to update. They run inside a transaction on the freshest copy of the
/// booking (see BookingActionsRepo), and mirror `firestore.rules`.
abstract class BookingTransitions {
  static const coach = AppConstants.roleCoach;
  static const trainee = AppConstants.roleTrainee;

  static const _active = {'pending', 'confirmed', 'reschedule_pending'};

  static Never _refuse() =>
      throw const BookingActionException(BookingActionError.notAllowed);

  static void _require(bool condition) {
    if (!condition) _refuse();
  }

  static String? _clean(String? text) {
    final t = text?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  static Map<String, dynamic> _clearedProposal() => {
    'proposedDate': null,
    'proposedStartTime': null,
    'proposedEndTime': null,
    'rescheduleReason': null,
    'rescheduledBy': null,
    'rescheduledAt': null,
  };

  // ----------------------------------------------------------- whole booking

  static Map<String, dynamic> approve(
    BookingModel b,
    String actor, {
    required DateTime now,
  }) {
    _require(actor == coach && b.status == 'pending');
    _requireNotExpired(b, now);
    return {'status': 'confirmed'};
  }

  static Map<String, dynamic> reject(
    BookingModel b,
    String actor, {
    String? reason,
  }) {
    _require(
      actor == coach &&
          (b.status == 'pending' || b.status == 'reschedule_pending'),
    );
    return {'status': 'rejected', 'rejectionReason': ?_clean(reason)};
  }

  /// Trainee cancels. A request the coach never approved can always be
  /// withdrawn; an approved booking only until its (first) session starts.
  static Map<String, dynamic> cancel(
    BookingModel b,
    String actor, {
    String? reason,
    required DateTime now,
  }) {
    _require(actor == trainee && _active.contains(b.status));
    if (_hasStartedApproved(b, now)) {
      throw const BookingActionException(BookingActionError.alreadyStarted);
    }
    return {'status': 'cancelled', 'cancellationReason': ?_clean(reason)};
  }

  /// Coach marks a single-session booking as done once its time has come.
  static Map<String, dynamic> completeBooking(
    BookingModel b,
    String actor, {
    required DateTime now,
  }) {
    _require(actor == coach && b.isSession && b.status == 'confirmed');
    final start = b.startDateTime;
    if (start == null || start.isAfter(now)) {
      throw const BookingActionException(BookingActionError.notStartedYet);
    }
    return {'status': 'completed'};
  }

  // ------------------------------------------------- single-session reschedule

  static Map<String, dynamic> proposeReschedule(
    BookingModel b,
    String actor, {
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
    required DateTime now,
  }) {
    _require(
      b.isSession &&
          (b.status == 'pending' || b.status == 'confirmed') &&
          (actor == coach || actor == trainee),
    );
    _requireNotExpired(b, now);
    _requireFuture(date, startTime, now);
    return {
      'status': 'reschedule_pending',
      'statusBeforeReschedule': b.status,
      'proposedDate': date,
      'proposedStartTime': startTime,
      'proposedEndTime': endTime,
      'rescheduleReason': reason.trim(),
      'rescheduledBy': actor,
      'rescheduledAt': FieldValue.serverTimestamp(),
      'previousDate': b.date,
      'previousStartTime': b.startTime,
      'previousEndTime': b.endTime,
      'sessions': FieldValue.delete(),
    };
  }

  /// The other side agrees: the booking moves to the new time and is
  /// confirmed (both people have now agreed on a time).
  static Map<String, dynamic> acceptReschedule(
    BookingModel b,
    String actor, {
    required DateTime now,
  }) {
    _require(
      b.isSession &&
          b.status == 'reschedule_pending' &&
          _isOtherSidesProposal(b.rescheduledBy, actor) &&
          b.proposedDate != null &&
          b.proposedStartTime != null,
    );
    _requireFuture(b.proposedDate!, b.proposedStartTime!, now);
    return {
      'status': 'confirmed',
      'date': b.proposedDate,
      'startTime': b.proposedStartTime,
      'endTime': b.proposedEndTime ?? b.endTime,
      'previousDate': b.date,
      'previousStartTime': b.startTime,
      'previousEndTime': b.endTime,
      'sessions': FieldValue.delete(),
      ..._clearedProposal(),
    };
  }

  /// The other side says no: the booking keeps its time and returns to the
  /// status it had before (a never-approved request stays `pending`).
  static Map<String, dynamic> declineReschedule(
    BookingModel b,
    String actor, {
    String? reason,
  }) {
    _require(
      b.isSession &&
          b.status == 'reschedule_pending' &&
          _isOtherSidesProposal(b.rescheduledBy, actor),
    );
    return {
      'status': b.restorableStatus,
      'previousDate': null,
      'previousStartTime': null,
      'previousEndTime': null,
      'rescheduleDeclineReason': ?_clean(reason),
      ..._clearedProposal(),
    };
  }

  // -------------------------------------------------------- monthly sessions

  static BookingSessionModel _session(BookingModel b, String sessionId) {
    final s = b.getSessionById(sessionId);
    if (s == null) _refuse();
    return s;
  }

  static Map<String, dynamic> _sessionsUpdate(
    BookingModel before,
    BookingModel after,
  ) => {
    'status': after.status,
    if (after.statusBeforeReschedule != before.statusBeforeReschedule)
      'statusBeforeReschedule': after.statusBeforeReschedule,
    'sessions': after.sessions.map((s) => s.toMap()).toList(),
  };

  static Map<String, dynamic> proposeSessionReschedule(
    BookingModel b,
    String actor, {
    required String sessionId,
    required String date,
    required String startTime,
    required String endTime,
    required String reason,
    required DateTime now,
  }) {
    _require(
      b.isMonthly &&
          _active.contains(b.status) &&
          (actor == coach || actor == trainee),
    );
    _requireNotExpired(b, now);
    final s = _session(b, sessionId);
    _require(s.canReschedule && !s.isReschedulePending);
    _requireFuture(date, startTime, now);
    final updated = b.proposeMonthlySessionReschedule(
      sessionId: sessionId,
      proposedDate: date,
      proposedStartTime: startTime,
      proposedEndTime: endTime,
      reason: reason.trim(),
      rescheduledBy: actor,
    );
    return _sessionsUpdate(b, updated);
  }

  /// Monthly: when the last open proposal is answered the package returns to
  /// its earlier status. Approving the package itself is a separate step.
  static Map<String, dynamic> acceptSessionReschedule(
    BookingModel b,
    String actor, {
    required String sessionId,
    required DateTime now,
  }) {
    _require(b.isMonthly && b.status == 'reschedule_pending');
    final s = _session(b, sessionId);
    _require(
      s.isReschedulePending &&
          _isOtherSidesProposal(s.rescheduledBy, actor) &&
          s.proposedDate != null &&
          s.proposedStartTime != null,
    );
    _requireFuture(s.proposedDate!, s.proposedStartTime!, now);
    return _sessionsUpdate(
      b,
      b.acceptMonthlySessionReschedule(sessionId: sessionId),
    );
  }

  static Map<String, dynamic> declineSessionReschedule(
    BookingModel b,
    String actor, {
    required String sessionId,
  }) {
    _require(b.isMonthly && b.status == 'reschedule_pending');
    final s = _session(b, sessionId);
    _require(
      s.isReschedulePending && _isOtherSidesProposal(s.rescheduledBy, actor),
    );
    return _sessionsUpdate(
      b,
      b.declineMonthlySessionReschedule(sessionId: sessionId),
    );
  }

  /// Coach ticks off a session of an approved package once it has started.
  static Map<String, dynamic> completeSession(
    BookingModel b,
    String actor, {
    required String sessionId,
    required DateTime now,
  }) {
    _require(actor == coach && b.isMonthly && b.isApproved);
    final s = _session(b, sessionId);
    _require(
      !s.isCompleted && s.status != 'cancelled' && !s.isReschedulePending,
    );
    if (!s.hasStarted(now)) {
      throw const BookingActionException(BookingActionError.notStartedYet);
    }
    return _sessionsUpdate(b, b.completeMonthlySession(sessionId: sessionId));
  }

  // ------------------------------------------------------------------ helpers

  /// Only the person who did NOT propose may answer a proposal.
  static bool _isOtherSidesProposal(String? proposer, String actor) =>
      (proposer == coach && actor == trainee) ||
      (proposer == trainee && actor == coach);

  /// Earliest start of the booking: the booked time for a single session,
  /// the first not-cancelled session for a monthly package.
  static DateTime? firstStart(BookingModel b) {
    if (b.isSession) return b.startDateTime;
    DateTime? first;
    for (final s in b.sessions) {
      if (s.status == 'cancelled') continue;
      final t = s.startDateTime;
      if (t != null && (first == null || t.isBefore(first))) first = t;
    }
    return first ?? b.startDateTime;
  }

  /// Latest time the booking refers to: its sessions and any proposal.
  static DateTime? _latestStart(BookingModel b) {
    final starts = <DateTime?>[
      if (b.isSession) ...[
        b.startDateTime,
        if (b.proposedDate != null && b.proposedStartTime != null)
          BookingSessionModel.parseStart(b.proposedDate!, b.proposedStartTime!),
      ] else
        for (final s in b.sessions) ...[
          s.startDateTime,
          if (s.proposedDate != null && s.proposedStartTime != null)
            BookingSessionModel.parseStart(
              s.proposedDate!,
              s.proposedStartTime!,
            ),
        ],
    ];
    DateTime? latest;
    for (final t in starts) {
      if (t != null && (latest == null || t.isAfter(latest))) latest = t;
    }
    return latest;
  }

  /// The coach never approved the request and every time it mentions has
  /// passed. Shown as "Expired"; it can no longer be approved. (Same rule as
  /// isOpenRequest in functions/src/utils/booking_request.ts.)
  static bool isExpired(BookingModel b, DateTime now) {
    final neverApproved =
        b.status == 'pending' ||
        (b.status == 'reschedule_pending' && b.restorableStatus == 'pending');
    if (!neverApproved) return false;
    final latest = _latestStart(b);
    return latest != null && !latest.isAfter(now);
  }

  /// 'expired' for expired requests, otherwise the stored status.
  static String displayStatus(BookingModel b, DateTime now) =>
      isExpired(b, now) ? 'expired' : b.status;

  static void _requireNotExpired(BookingModel b, DateTime now) {
    if (isExpired(b, now)) {
      throw const BookingActionException(BookingActionError.expired);
    }
  }

  static void _requireFuture(String date, String startTime, DateTime now) {
    final t = BookingSessionModel.parseStart(date, startTime);
    if (t == null || !t.isAfter(now)) {
      throw const BookingActionException(BookingActionError.timeInPast);
    }
  }

  static bool _hasStartedApproved(BookingModel b, DateTime now) {
    if (!b.isApproved) return false;
    final start = firstStart(b);
    return start != null && !start.isAfter(now);
  }

  /// Which buttons a screen may show (keeps UI and rules in step).
  static bool canCompleteBooking(BookingModel b, DateTime now) =>
      b.isSession &&
      b.status == 'confirmed' &&
      (b.startDateTime?.isAfter(now) == false);

  static bool canActOnSessions(BookingModel b) => _active.contains(b.status);

  static bool canCompleteSession(
    BookingModel b,
    BookingSessionModel s,
    DateTime now,
  ) =>
      b.isMonthly &&
      b.isApproved &&
      !s.isCompleted &&
      s.status != 'cancelled' &&
      !s.isReschedulePending &&
      s.hasStarted(now);

  static bool canCancel(BookingModel b, DateTime now) =>
      _active.contains(b.status) &&
      !isExpired(b, now) &&
      !_hasStartedApproved(b, now);
}
