import 'package:cloud_firestore/cloud_firestore.dart';

class BookingSessionModel {
  final String id, date, startTime, endTime, status;
  final String? proposedDate, proposedStartTime, proposedEndTime;
  final String? rescheduleReason, rescheduledBy;
  final DateTime? rescheduledAt;
  final String? previousDate, previousStartTime, previousEndTime;

  const BookingSessionModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = 'scheduled',
    this.proposedDate,
    this.proposedStartTime,
    this.proposedEndTime,
    this.rescheduleReason,
    this.rescheduledBy,
    this.rescheduledAt,
    this.previousDate,
    this.previousStartTime,
    this.previousEndTime,
  });

  bool get isReschedulePending => status == 'reschedule_pending';
  bool get isCompleted => status == 'completed';
  bool get isScheduled => status == 'scheduled' || status == 'rescheduled';
  bool get canReschedule => !isCompleted && status != 'cancelled';

  BookingSessionModel proposeReschedule({
    required String newDate,
    required String newStartTime,
    required String newEndTime,
    required String reason,
    required String by,
    DateTime? at,
  }) =>
      BookingSessionModel(
        id: id,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: 'reschedule_pending',
        proposedDate: newDate,
        proposedStartTime: newStartTime,
        proposedEndTime: newEndTime,
        rescheduleReason: reason,
        rescheduledBy: by,
        rescheduledAt: at ?? DateTime.now(),
        previousDate: date,
        previousStartTime: startTime,
        previousEndTime: endTime,
      );

  BookingSessionModel acceptReschedule() => BookingSessionModel(
        id: id,
        date: proposedDate ?? date,
        startTime: proposedStartTime ?? startTime,
        endTime: proposedEndTime ?? endTime,
        status: 'scheduled',
        previousDate: date,
        previousStartTime: startTime,
        previousEndTime: endTime,
      );

  BookingSessionModel declineReschedule() => BookingSessionModel(
        id: id,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: 'scheduled',
      );

  BookingSessionModel markCompleted() => copyWith(status: 'completed');

  factory BookingSessionModel.fromJson(Map<String, dynamic> json) => BookingSessionModel(
        id: json['id'] as String? ?? '',
        date: json['date'] as String? ?? '',
        startTime: json['startTime'] as String? ?? '',
        endTime: json['endTime'] as String? ?? '',
        status: json['status'] as String? ?? 'scheduled',
        proposedDate: json['proposedDate'] as String?,
        proposedStartTime: json['proposedStartTime'] as String?,
        proposedEndTime: json['proposedEndTime'] as String?,
        rescheduleReason: json['rescheduleReason'] as String?,
        rescheduledBy: json['rescheduledBy'] as String?,
        rescheduledAt: _parseDate(json['rescheduledAt']),
        previousDate: json['previousDate'] as String?,
        previousStartTime: json['previousStartTime'] as String?,
        previousEndTime: json['previousEndTime'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'status': status,
        if (proposedDate != null) 'proposedDate': proposedDate,
        if (proposedStartTime != null) 'proposedStartTime': proposedStartTime,
        if (proposedEndTime != null) 'proposedEndTime': proposedEndTime,
        if (rescheduleReason != null) 'rescheduleReason': rescheduleReason,
        if (rescheduledBy != null) 'rescheduledBy': rescheduledBy,
        if (rescheduledAt != null) 'rescheduledAt': rescheduledAt!.toIso8601String(),
        if (previousDate != null) 'previousDate': previousDate,
        if (previousStartTime != null) 'previousStartTime': previousStartTime,
        if (previousEndTime != null) 'previousEndTime': previousEndTime,
      };

  static DateTime? _parseDate(dynamic v) =>
      v is Timestamp ? v.toDate() : (v is String ? DateTime.tryParse(v) : null);

  BookingSessionModel copyWith({
    String? id,
    String? date,
    String? startTime,
    String? endTime,
    String? status,
    String? proposedDate,
    String? proposedStartTime,
    String? proposedEndTime,
    String? rescheduleReason,
    String? rescheduledBy,
    DateTime? rescheduledAt,
    String? previousDate,
    String? previousStartTime,
    String? previousEndTime,
  }) =>
      BookingSessionModel(
        id: id ?? this.id,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        status: status ?? this.status,
        proposedDate: proposedDate ?? this.proposedDate,
        proposedStartTime: proposedStartTime ?? this.proposedStartTime,
        proposedEndTime: proposedEndTime ?? this.proposedEndTime,
        rescheduleReason: rescheduleReason ?? this.rescheduleReason,
        rescheduledBy: rescheduledBy ?? this.rescheduledBy,
        rescheduledAt: rescheduledAt ?? this.rescheduledAt,
        previousDate: previousDate ?? this.previousDate,
        previousStartTime: previousStartTime ?? this.previousStartTime,
        previousEndTime: previousEndTime ?? this.previousEndTime,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingSessionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          status == other.status &&
          proposedDate == other.proposedDate &&
          proposedStartTime == other.proposedStartTime &&
          proposedEndTime == other.proposedEndTime &&
          rescheduleReason == other.rescheduleReason &&
          rescheduledBy == other.rescheduledBy &&
          rescheduledAt == other.rescheduledAt &&
          previousDate == other.previousDate &&
          previousStartTime == other.previousStartTime &&
          previousEndTime == other.previousEndTime;

  @override
  int get hashCode => Object.hash(
        id,
        date,
        startTime,
        endTime,
        status,
        proposedDate,
        proposedStartTime,
        proposedEndTime,
        rescheduleReason,
        rescheduledBy,
        rescheduledAt,
        previousDate,
        previousStartTime,
        previousEndTime,
      );
}
