import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/auth_service/auth_service.dart';
import '../../../../core/services/logger_service/logger_service.dart';
import '../../../notifications/data/helpers/notification_safe_dispatcher.dart';
import '../../../trainee_setup/data/models/trainee_profile_model.dart';
import '../../../trainee_setup/data/repos/trainee_setup_repo.dart';
import '../data_source/booking_request_remote_data_source.dart';
import '../models/booking_model.dart';

class BookingRequestRepo {
  final BookingRequestRemoteDataSource remoteDataSource;
  final AuthService authService;
  final TraineeSetupRepo traineeSetupRepo;

  BookingRequestRepo({
    required this.remoteDataSource,
    required this.authService,
    required this.traineeSetupRepo,
  });

  Future<Either<Failure, List<String>>> getBookedSlots({
    required String coachUid,
    required String date,
  }) async {
    try {
      LoggerService.info(
        'Fetching booked slots for coach: $coachUid on $date',
        tag: 'BookingRequestRepo',
      );

      final bookedSlots = await remoteDataSource.getBookedSlots(
        coachUid: coachUid,
        date: date,
      );

      return Right(bookedSlots);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to fetch booked slots: $e',
        tag: 'BookingRequestRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
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
      LoggerService.info(
        'Creating booking request for coach: ${booking.coachUid}',
        tag: 'BookingRequestRepo',
      );

      final bookingId = await remoteDataSource.createBooking(booking);
      final trainee = await getCurrentTrainee();
      final traineeName = (trainee != null && trainee.name.isNotEmpty)
          ? trainee.name
          : (booking.traineeName.isNotEmpty ? booking.traineeName : 'Trainee');
      NotificationSafeDispatcher.dispatch(
        (d) => d.dispatchNewBooking(
          booking: booking.copyWith(id: bookingId),
          traineeName: traineeName,
        ),
      );

      return Right(bookingId);
    } catch (e, stackTrace) {
      LoggerService.error(
        'Failed to create booking: $e',
        tag: 'BookingRequestRepo',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
