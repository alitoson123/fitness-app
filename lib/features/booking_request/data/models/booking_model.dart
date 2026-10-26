import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String coachUid;
  final String coachName;
  final String coachPhotoUrl;
  final String traineeUid;
  final String traineeName;
  final String traineePhotoUrl;
  final String sport;
  final String date;
  final String startTime;
  final String endTime;
  final double price;
  final String currency;
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
    required this.date,
    required this.startTime,
    required this.endTime,
    this.price = 0.0,
    this.currency = 'SAR',
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

  factory BookingModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return BookingModel(
      id: id ?? json['id'] as String? ?? '',
      coachUid: json['coachUid'] as String? ?? '',
      coachName: json['coachName'] as String? ?? '',
      coachPhotoUrl: json['coachPhotoUrl'] as String? ?? '',
      traineeUid: json['traineeUid'] as String? ?? '',
      traineeName: json['traineeName'] as String? ?? '',
      traineePhotoUrl: json['traineePhotoUrl'] as String? ?? '',
      sport: json['sport'] as String? ?? '',
      date: json['date'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'SAR',
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      rejectionReason: json['rejectionReason'] as String?,
      proposedDate: json['proposedDate'] as String?,
      proposedStartTime: json['proposedStartTime'] as String?,
      proposedEndTime: json['proposedEndTime'] as String?,
      rescheduleReason: json['rescheduleReason'] as String?,
      rescheduledBy: json['rescheduledBy'] as String?,
      rescheduledAt: _parseDate(json['rescheduledAt']),
      previousDate: json['previousDate'] as String?,
      previousStartTime: json['previousStartTime'] as String?,
      previousEndTime: json['previousEndTime'] as String?,
      cancellationReason: json['cancellationReason'] as String?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coachUid': coachUid,
      'coachName': coachName,
      'coachPhotoUrl': coachPhotoUrl,
      'traineeUid': traineeUid,
      'traineeName': traineeName,
      'traineePhotoUrl': traineePhotoUrl,
      'sport': sport,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'price': price,
      'currency': currency,
      'notes': notes,
      'status': status,
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
      if (proposedDate != null) 'proposedDate': proposedDate,
      if (proposedStartTime != null) 'proposedStartTime': proposedStartTime,
      if (proposedEndTime != null) 'proposedEndTime': proposedEndTime,
      if (rescheduleReason != null) 'rescheduleReason': rescheduleReason,
      if (rescheduledBy != null) 'rescheduledBy': rescheduledBy,
      if (rescheduledAt != null)
        'rescheduledAt': Timestamp.fromDate(rescheduledAt!),
      if (previousDate != null) 'previousDate': previousDate,
      if (previousStartTime != null) 'previousStartTime': previousStartTime,
      if (previousEndTime != null) 'previousEndTime': previousEndTime,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _parseDate(dynamic val) {
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val);
    return null;
  }
}
