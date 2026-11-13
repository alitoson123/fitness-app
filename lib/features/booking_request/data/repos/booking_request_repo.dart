import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../../generated/l10n.dart';
import '../../../notifications/data/helpers/notification_safe_dispatcher.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';
import '../../../trainee_setup/data/repos/trainee_setup_repo.dart';
import '../data_source/booking_request_remote_data_source.dart';
import '../models/booking_model.dart';
import '../models/busy_range.dart';

/// The server refused the request; [reason] lets the screen react (e.g.
/// reload the times when someone else just took the slot).
class BookingRequestFailure extends Failure {
  final String reason;
  final String? conflictDate;
  final String? conflictStartTime;

  BookingRequestFailure({
    required this.reason,
    required super.errorMessage,
    this.conflictDate,
    this.conflictStartTime,
  });

  bool get isSlotTaken => reason == 'slot_taken';
}

class BookingRequestRepo {
  /// Same limit as MAX_OPEN_REQUESTS_PER_COACH in the Cloud Function.
  static const maxOpenRequestsPerCoach = 3;

  final BookingRequestRemoteDataSource remoteDataSource;
  final AuthService authService;
  final TraineeSetupRepo traineeSetupRepo;

  BookingRequestRepo({
    required this.remoteDataSource,
    required this.authService,
    required this.traineeSetupRepo,
  });

  Future<Either<Failure, List<BusyRange>>> getBusyRanges({
    required String coachUid,
    required String date,
    int sessionDurationMinutes = 60,
  }) async {
    try {
      return Right(
        await remoteDataSource.getBusyRanges(
          coachUid: coachUid,
          date: date,
          fallbackDurationMinutes: sessionDurationMinutes,
        ),
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to fetch busy times: $e',
        tag: 'BookingRequestRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: S.current.slotsLoadFailed));
    }
  }

  Future<TraineeProfileModel?> getCurrentTrainee() async {
    final cached = await traineeSetupRepo.getCachedTraineeProfile();
    if (cached != null) return cached;
    final user = authService.currentUser;
    if (user != null) {
      return await traineeSetupRepo.getTraineeProfile(targetUid: user.uid);
    }
    return null;
  }

  Future<Either<Failure, String>> createBooking(BookingModel booking) async {
    try {
      final created = await remoteDataSource.createBooking(booking);
      final trainee = await getCurrentTrainee();
      final traineeName = (trainee != null && trainee.name.isNotEmpty)
          ? trainee.name
          : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee');
      NotificationSafeDispatcher.dispatch(
        (d) => d.dispatchNewBooking(
          booking: booking.copyWith(id: created.id, price: created.price),
          traineeName: traineeName,
        ),
      );
      return Right(created.id);
    } on BookingRequestException catch (e) {
      LoggerService.warning(
        'Booking request refused: ${e.reason}',
        tag: 'BookingRequestRepo',
      );
      return Left(
        BookingRequestFailure(
          reason: e.reason,
          errorMessage: messageFor(e, isMonthly: booking.isMonthly),
          conflictDate: e.conflictDate,
          conflictStartTime: e.conflictStartTime,
        ),
      );
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to create booking: $e',
        tag: 'BookingRequestRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(
        ServerFailure(errorMessage: S.current.unexpectedErrorMessage),
      );
    }
  }

  static String messageFor(
    BookingRequestException e, {
    bool isMonthly = false,
  }) {
    final s = S.current;
    switch (e.reason) {
      case 'slot_taken':
        return isMonthly &&
                e.conflictDate != null &&
                e.conflictStartTime != null
            ? s.bookingSlotTakenMonthly(e.conflictDate!, e.conflictStartTime!)
            : s.bookingSlotTaken;
      case 'outside_hours':
        return s.bookingOutsideHours;
      case 'in_past':
        return s.bookingTimeInPast;
      case 'too_far_ahead':
        return s.bookingTooFarAhead;
      case 'too_many_requests':
        return s.bookingTooManyRequests(maxOpenRequestsPerCoach);
      case 'coach_unavailable':
        return s.bookingCoachUnavailable;
      case 'not_a_trainee':
        return s.bookingNotAllowedForAccount;
      case 'monthly_not_offered':
        return s.bookingMonthlyNotOffered;
      case 'sport_not_offered':
        return s.bookingSportNotOffered;
      case 'location_not_offered':
        return s.bookingLocationNotOffered;
      case 'invalid_request':
        return s.bookingInvalidRequest;
      case 'network':
        return s.connectionErrorMessage;
      default:
        return s.unexpectedErrorMessage;
    }
  }
}
