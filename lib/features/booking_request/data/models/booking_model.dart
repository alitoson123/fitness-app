import 'booking_serializer.dart';

class BookingModel {
  final String id;
  final String coachUid;
  final String coachName;
  final String coachPhotoUrl;
  final String traineeUid;
  final String traineeName;
  final String traineePhotoUrl;
  final String sport;
  final String bookingType;
  final String date;
  final String startTime;
  final String endTime;
  final double price;
  final String currency;
  final int durationMonths;
  final String notes;
  final String status;
  final String? rejectionReason;
  final String? proposedDate;
  final String? proposedStartTime;
  final String? proposedEndTime;
  final String? rescheduleReason;
  final String? rescheduledBy;
  final DateTime? rescheduledAt;
  final String? previousDate;
  final String? previousStartTime;
  final String? previousEndTime;
  final String? cancellationReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    required this.date,
    required this.startTime,
    required this.endTime,
    this.price = 0.0,
    this.currency = 'USD',
    this.durationMonths = 1,
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
    String? date,
    String? startTime,
    String? endTime,
    double? price,
    String? currency,
    int? durationMonths,
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
    return BookingModel(
      id: id ?? this.id,
      coachUid: coachUid ?? this.coachUid,
      coachName: coachName ?? this.coachName,
      coachPhotoUrl: coachPhotoUrl ?? this.coachPhotoUrl,
      traineeUid: traineeUid ?? this.traineeUid,
      traineeName: traineeName ?? this.traineeName,
      traineePhotoUrl: traineePhotoUrl ?? this.traineePhotoUrl,
      sport: sport ?? this.sport,
      bookingType: bookingType ?? this.bookingType,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      durationMonths: durationMonths ?? this.durationMonths,
      notes: notes ?? this.notes,
      status: status ?? this.status,
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
