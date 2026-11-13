import '../../../../generated/l10n.dart';
import 'booking_serializer.dart';
import 'booking_session_model.dart';

class BookingModel {
  /// Set by the `onAuthUserDeleted` Cloud Function when the other
  /// participant deleted their account.
  static const String accountDeletedReason = 'account_deleted';

  /// Turns system reason codes into localized text; free text written by a
  /// user is shown as-is.
  static String displayCancellationReason(String reason, S s) =>
      reason == accountDeletedReason ? s.cancelledAccountDeletedReason : reason;

  final String id, coachUid, coachName, coachPhotoUrl;
  final String traineeUid, traineeName, traineePhotoUrl;
  final String sport, bookingType, date, startTime, endTime;
  final String trainingLocation;
  final bool isOnline;
  final double price;
  final String currency;
  final int durationMonths;
  final List<BookingSessionModel> sessions;
  final String notes, status;
  final String? rejectionReason, proposedDate, proposedStartTime, proposedEndTime;
  final String? rescheduleReason, rescheduledBy, previousDate, previousStartTime;
  final String? previousEndTime, cancellationReason;
  final DateTime? rescheduledAt, createdAt, updatedAt;

  const BookingModel({
    required this.id,
    required this.coachUid,
    this.coachName = '',
    this.coachPhotoUrl = '',
    required this.traineeUid,
    this.traineeName = '',
    this.traineePhotoUrl = '',
    required this.sport,
    this.bookingType = 'session',
    this.trainingLocation = '',
    this.isOnline = false,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.price = 0.0,
    this.currency = 'USD',
    this.durationMonths = 1,
    this.sessions = const [],
    this.notes = '',
    this.status = 'pending',
    this.rejectionReason,
    this.proposedDate,
    this.proposedStartTime,
    this.proposedEndTime,
    this.rescheduleReason,
    this.rescheduledBy,
    this.rescheduledAt,
    this.previousDate,
    this.previousStartTime,
    this.previousEndTime,
    this.cancellationReason,
    this.createdAt,
    this.updatedAt,
  });

  bool get isReschedulePending => status == 'reschedule_pending';
  bool get isMonthly => bookingType == 'monthly';
  bool get isSession => bookingType != 'monthly';
  int get sessionsCount => sessions.isNotEmpty ? sessions.length : 1;
  double get priceUSD => price;

  BookingSessionModel? getSessionById(String id) =>
      sessions.where((s) => s.id == id).firstOrNull;

  bool get hasPendingSessionReschedule =>
      sessions.any((s) => s.isReschedulePending);

  List<BookingSessionModel> get pendingRescheduleSessions =>
      sessions.where((s) => s.isReschedulePending).toList();

  List<BookingSessionModel> get completedSessions =>
      sessions.where((s) => s.isCompleted).toList();

  int get completedSessionsCount => completedSessions.length;

  double get progressRatio => sessionsCount > 0
      ? (completedSessionsCount / sessionsCount).clamp(0.0, 1.0)
      : 0.0;

  BookingSessionModel? get nextUpcomingSession {
    final up = sessions.where((s) => !s.isCompleted && s.status != 'cancelled').toList();
    if (up.isEmpty) return null;
    up.sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.startTime.compareTo(b.startTime);
    });
    return up.first;
  }

  BookingModel proposeMonthlySessionReschedule({
    required String sessionId,
    required String proposedDate,
    required String proposedStartTime,
    required String proposedEndTime,
    required String reason,
    required String rescheduledBy,
  }) {
    final updatedSessions = sessions.map((s) {
      if (s.id == sessionId) {
        return s.proposeReschedule(
          newDate: proposedDate,
          newStartTime: proposedStartTime,
          newEndTime: proposedEndTime,
          reason: reason,
          by: rescheduledBy,
        );
      }
      return s;
    }).toList();

    return copyWith(
      status: 'reschedule_pending',
      sessions: updatedSessions,
    );
  }

  BookingModel acceptMonthlySessionReschedule({
    required String sessionId,
    String? restoredStatus,
  }) {
    final updatedSessions = sessions.map((s) {
      if (s.id == sessionId) return s.acceptReschedule();
      return s;
    }).toList();

    final hasPending = updatedSessions.any((s) => s.isReschedulePending);
    final targetStatus = hasPending
        ? 'reschedule_pending'
        : (restoredStatus ?? 'confirmed');

    return copyWith(status: targetStatus, sessions: updatedSessions);
  }

  BookingModel declineMonthlySessionReschedule({
    required String sessionId,
    String? restoredStatus,
  }) {
    final updatedSessions = sessions.map((s) {
      if (s.id == sessionId) return s.declineReschedule();
      return s;
    }).toList();

    final hasPending = updatedSessions.any((s) => s.isReschedulePending);
    final targetStatus = hasPending
        ? 'reschedule_pending'
        : (restoredStatus ?? 'confirmed');

    return copyWith(status: targetStatus, sessions: updatedSessions);
  }

  BookingModel completeMonthlySession({
    required String sessionId,
  }) {
    final updatedSessions = sessions.map((s) {
      if (s.id == sessionId) return s.markCompleted();
      return s;
    }).toList();

    final allDone =
        updatedSessions.isNotEmpty &&
        updatedSessions.every((s) => s.isCompleted || s.status == 'cancelled');
    final targetStatus = allDone ? 'completed' : status;

    return copyWith(status: targetStatus, sessions: updatedSessions);
  }

  factory BookingModel.fromJson(Map<String, dynamic> json, {String? id}) =>
      BookingSerializer.fromJson(json, id: id);

  Map<String, dynamic> toMap() => BookingSerializer.toMap(this);

  BookingModel copyWith({
    String? id,
    String? coachUid,
    String? coachName,
    String? coachPhotoUrl,
    String? traineeUid,
    String? traineeName,
    String? traineePhotoUrl,
    String? sport,
    String? bookingType,
    String? trainingLocation,
    bool? isOnline,
    String? date,
    String? startTime,
    String? endTime,
    double? price,
    String? currency,
    int? durationMonths,
    List<BookingSessionModel>? sessions,
    String? notes,
    String? status,
    String? rejectionReason,
    String? proposedDate,
    String? proposedStartTime,
    String? proposedEndTime,
    String? rescheduleReason,
    String? rescheduledBy,
    DateTime? rescheduledAt,
    String? previousDate,
    String? previousStartTime,
    String? previousEndTime,
    String? cancellationReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final resolvedBookingType = bookingType ?? this.bookingType;
    final resolvedDate = date ?? this.date;
    final resolvedStartTime = startTime ?? this.startTime;
    final resolvedEndTime = endTime ?? this.endTime;
    final resolvedStatus = status ?? this.status;

    List<BookingSessionModel> resolvedSessions;
    if (sessions != null) {
      resolvedSessions = sessions;
    } else if (resolvedBookingType != 'monthly') {
      resolvedSessions = [
        BookingSessionModel(
          id: id ?? this.id,
          date: resolvedDate,
          startTime: resolvedStartTime,
          endTime: resolvedEndTime,
          status: resolvedStatus,
          proposedDate: proposedDate ?? this.proposedDate,
          proposedStartTime: proposedStartTime ?? this.proposedStartTime,
          proposedEndTime: proposedEndTime ?? this.proposedEndTime,
          rescheduleReason: rescheduleReason ?? this.rescheduleReason,
          rescheduledBy: rescheduledBy ?? this.rescheduledBy,
          rescheduledAt: rescheduledAt ?? this.rescheduledAt,
          previousDate: previousDate ?? this.previousDate,
          previousStartTime: previousStartTime ?? this.previousStartTime,
          previousEndTime: previousEndTime ?? this.previousEndTime,
        ),
      ];
    } else {
      resolvedSessions = this.sessions;
    }

    return BookingModel(
      id: id ?? this.id,
      coachUid: coachUid ?? this.coachUid,
      coachName: coachName ?? this.coachName,
      coachPhotoUrl: coachPhotoUrl ?? this.coachPhotoUrl,
      traineeUid: traineeUid ?? this.traineeUid,
      traineeName: traineeName ?? this.traineeName,
      traineePhotoUrl: traineePhotoUrl ?? this.traineePhotoUrl,
      sport: sport ?? this.sport,
      bookingType: resolvedBookingType,
      trainingLocation: trainingLocation ?? this.trainingLocation,
      isOnline: isOnline ?? this.isOnline,
      date: resolvedDate,
      startTime: resolvedStartTime,
      endTime: resolvedEndTime,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      durationMonths: durationMonths ?? this.durationMonths,
      sessions: resolvedSessions,
      notes: notes ?? this.notes,
      status: resolvedStatus,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      proposedDate: proposedDate ?? this.proposedDate,
      proposedStartTime: proposedStartTime ?? this.proposedStartTime,
      proposedEndTime: proposedEndTime ?? this.proposedEndTime,
      rescheduleReason: rescheduleReason ?? this.rescheduleReason,
      rescheduledBy: rescheduledBy ?? this.rescheduledBy,
      rescheduledAt: rescheduledAt ?? this.rescheduledAt,
      previousDate: previousDate ?? this.previousDate,
      previousStartTime: previousStartTime ?? this.previousStartTime,
      previousEndTime: previousEndTime ?? this.previousEndTime,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
