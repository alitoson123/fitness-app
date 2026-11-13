import 'package:cloud_firestore/cloud_firestore.dart';
import 'booking_model.dart';
import 'booking_session_model.dart';

class BookingSerializer {
  static BookingModel fromJson(Map<String, dynamic> json, {String? id}) {
    final bookingType = json['bookingType'] as String? ?? 'session';
    final isMonthly = bookingType == 'monthly';

    final rawDate = json['date'] as String? ?? '';
    final rawStart = json['startTime'] as String? ?? '';
    final rawEnd = json['endTime'] as String? ?? '';
    final rawStatus = json['status'] as String? ?? 'pending';

    final sessions = isMonthly
        ? _parseSessions(json['sessions'])
        : [
            BookingSessionModel(
              id: id ?? json['id'] as String? ?? 's_1',
              date: rawDate,
              startTime: rawStart,
              endTime: rawEnd,
              status: rawStatus,
              proposedDate: json['proposedDate'] as String?,
              proposedStartTime: json['proposedStartTime'] as String?,
              proposedEndTime: json['proposedEndTime'] as String?,
              rescheduleReason: json['rescheduleReason'] as String?,
              rescheduledBy: json['rescheduledBy'] as String?,
              rescheduledAt: _parseDate(json['rescheduledAt']),
              previousDate: json['previousDate'] as String?,
              previousStartTime: json['previousStartTime'] as String?,
              previousEndTime: json['previousEndTime'] as String?,
            ),
          ];

    return BookingModel(
      id: id ?? json['id'] as String? ?? '',
      coachUid: json['coachUid'] as String? ?? '',
      coachName: json['coachName'] as String? ?? '',
      coachPhotoUrl: json['coachPhotoUrl'] as String? ?? '',
      traineeUid: json['traineeUid'] as String? ?? '',
      traineeName: json['traineeName'] as String? ?? '',
      traineePhotoUrl: json['traineePhotoUrl'] as String? ?? '',
      sport: json['sport'] as String? ?? '',
      bookingType: bookingType,
      trainingLocation: json['trainingLocation'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      date: rawDate,
      startTime: rawStart,
      endTime: rawEnd,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'USD',
      durationMonths: (json['durationMonths'] as num?)?.toInt() ?? 1,
      sessions: sessions,
      notes: json['notes'] as String? ?? '',
      status: rawStatus,
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
      statusBeforeReschedule: json['statusBeforeReschedule'] as String?,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static Map<String, dynamic> toMap(BookingModel booking) {
    final isMonthly = booking.bookingType == 'monthly';

    return {
      'id': booking.id,
      'coachUid': booking.coachUid,
      'coachName': booking.coachName,
      'coachPhotoUrl': booking.coachPhotoUrl,
      'traineeUid': booking.traineeUid,
      'traineeName': booking.traineeName,
      if (booking.traineePhotoUrl.isNotEmpty)
        'traineePhotoUrl': booking.traineePhotoUrl,
      'sport': booking.sport,
      'bookingType': booking.bookingType,
      'trainingLocation': booking.trainingLocation,
      'isOnline': booking.isOnline,
      'date': booking.date,
      'startTime': booking.startTime,
      'endTime': booking.endTime,
      'price': booking.price,
      'currency': booking.currency,
      if (isMonthly) 'durationMonths': booking.durationMonths,
      if (isMonthly && booking.sessions.isNotEmpty)
        'sessions': booking.sessions.map((s) => s.toMap()).toList(),
      if (booking.notes.isNotEmpty) 'notes': booking.notes,
      'status': booking.status,
      if (booking.rejectionReason != null)
        'rejectionReason': booking.rejectionReason,
      if (booking.proposedDate != null)
        'proposedDate': booking.proposedDate,
      if (booking.proposedStartTime != null)
        'proposedStartTime': booking.proposedStartTime,
      if (booking.proposedEndTime != null)
        'proposedEndTime': booking.proposedEndTime,
      if (booking.rescheduleReason != null)
        'rescheduleReason': booking.rescheduleReason,
      if (booking.rescheduledBy != null)
        'rescheduledBy': booking.rescheduledBy,
      if (booking.rescheduledAt != null)
        'rescheduledAt': Timestamp.fromDate(booking.rescheduledAt!),
      if (booking.previousDate != null)
        'previousDate': booking.previousDate,
      if (booking.previousStartTime != null)
        'previousStartTime': booking.previousStartTime,
      if (booking.previousEndTime != null)
        'previousEndTime': booking.previousEndTime,
      if (booking.cancellationReason != null)
        'cancellationReason': booking.cancellationReason,
      if (booking.statusBeforeReschedule != null)
        'statusBeforeReschedule': booking.statusBeforeReschedule,
      'createdAt': booking.createdAt != null
          ? Timestamp.fromDate(booking.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  static List<BookingSessionModel> _parseSessions(dynamic val) {
    if (val is List) {
      return val
          .whereType<Map>()
          .map((item) => BookingSessionModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    return const [];
  }

  static DateTime? _parseDate(dynamic val) {
    if (val is Timestamp) return val.toDate();
    if (val is String) return DateTime.tryParse(val);
    return null;
  }
}
