import 'package:cloud_functions/cloud_functions.dart';
import 'package:fitness_app/core/constant/app_constants.dart';
import 'package:fitness_app/core/services/database_service/firestore_service.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import '../models/booking_model.dart';
import '../models/busy_range.dart';

/// Calls a Cloud Function and returns its result (swappable in tests).
typedef CallableInvoker =
    Future<Map<String, dynamic>> Function(
      String name,
      Map<String, dynamic> data,
    );

Future<Map<String, dynamic>> _callFirebaseFunction(
  String name,
  Map<String, dynamic> data,
) async {
  final result = await FirebaseFunctions.instance
      .httpsCallable(name)
      .call(data);
  final value = result.data;
  return value is Map ? Map<String, dynamic>.from(value) : const {};
}

/// Why the server refused a booking request (see
/// functions/src/utils/booking_request.ts for the list of reasons).
class BookingRequestException implements Exception {
  final String reason;

  /// The requested time that clashes (for `slot_taken`, `in_past`, ...).
  final String? conflictDate;
  final String? conflictStartTime;

  const BookingRequestException(
    this.reason, {
    this.conflictDate,
    this.conflictStartTime,
  });

  @override
  String toString() => 'BookingRequestException($reason)';
}

class BookingRequestRemoteDataSource {
  final FirestoreService firestoreService;
  final CallableInvoker _call;
  final Duration Function() _utcOffset;

  BookingRequestRemoteDataSource({
    required this.firestoreService,
    CallableInvoker? callFunction,
    Duration Function()? utcOffset,
  }) : _call = callFunction ?? _callFirebaseFunction,
       _utcOffset = utcOffset ?? (() => DateTime.now().timeZoneOffset);

  /// Periods on [date] (`YYYY-MM-DD`) when [coachUid] is already taken.
  ///
  /// Reads the public `coach_busy_slots/{coachUid}` document, which the
  /// server rebuilds whenever a booking changes. Newer documents carry
  /// start-end `ranges`; older ones only start times, which are assumed to
  /// last [fallbackDurationMinutes].
  Future<List<BusyRange>> getBusyRanges({
    required String coachUid,
    required String date,
    int fallbackDurationMinutes = 60,
  }) async {
    final doc = await firestoreService.getDoc(
      collection: AppConstants.coachBusySlotsCollection,
      docId: coachUid,
    );
    final data = doc.data();

    final ranges = data?['ranges'];
    if (ranges is Map) {
      final forDate = ranges[date];
      if (forDate is! List) return const [];
      return forDate
          .whereType<String>()
          .map(BusyRange.parse)
          .whereType<BusyRange>()
          .toList();
    }

    final slots = data?['slots'];
    if (slots is! Map) return const [];
    final forDate = slots[date];
    if (forDate is! List) return const [];
    return forDate
        .whereType<String>()
        .map((s) => BusyRange.fromStart(s, fallbackDurationMinutes))
        .whereType<BusyRange>()
        .toList();
  }

  /// Asks the `createBooking` Cloud Function to create the booking. The
  /// server decides price, names and end times; we only send the choices.
  /// Returns the new booking's id and the price the server charged.
  Future<({String id, double price})> createBooking(
    BookingModel booking,
  ) async {
    LoggerService.info(
      'Requesting booking with coach: ${booking.coachUid} (type: ${booking.bookingType}, sessions: ${booking.sessions.length})',
      tag: 'BookingRequestRemoteDataSource',
    );

    final sessions = booking.isMonthly
        ? booking.sessions
              .map((s) => {'date': s.date, 'startTime': s.startTime})
              .toList()
        : [
            {'date': booking.date, 'startTime': booking.startTime},
          ];

    try {
      final result = await _call('createBooking', {
        'coachUid': booking.coachUid,
        'bookingType': booking.bookingType,
        'sport': booking.sport,
        'isOnline': booking.isOnline,
        'trainingLocation': booking.isOnline ? '' : booking.trainingLocation,
        'notes': booking.notes,
        'sessions': sessions,
        'utcOffsetMinutes': _utcOffset().inMinutes,
      });
      final id = result['bookingId'];
      if (id is! String || id.isEmpty) {
        throw const BookingRequestException('unexpected');
      }
      final price = result['price'];
      return (id: id, price: price is num ? price.toDouble() : booking.price);
    } on FirebaseFunctionsException catch (e) {
      final details = e.details is Map ? e.details as Map : const {};
      final conflict = details['conflict'] is Map
          ? details['conflict'] as Map
          : const {};
      final reason =
          details['reason'] as String? ??
          switch (e.code) {
            'unavailable' || 'deadline-exceeded' => 'network',
            'unauthenticated' || 'permission-denied' => 'not_a_trainee',
            _ => 'unexpected',
          };
      throw BookingRequestException(
        reason,
        conflictDate: conflict['date'] as String?,
        conflictStartTime: conflict['startTime'] as String?,
      );
    }
  }
}
