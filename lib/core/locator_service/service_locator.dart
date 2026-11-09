import 'package:get_it/get_it.dart';
import '../../features/auth/core/data/data_source/auth_local_data_source.dart';
import '../../features/auth/choose_role/presentation/view_model/choose_role_cubit/choose_role_cubit.dart';
import '../../features/auth/phone_sign_in/data/data_source/phone_auth_remote_data_source.dart';
import '../../features/auth/phone_sign_in/data/repos/phone_auth_repo.dart';
import '../../features/auth/phone_sign_in/presentation/view_model/phone_auth_cubit/phone_auth_cubit.dart';
import '../../features/onboarding/data/data_source/onboarding_local_data_source.dart';
import '../../features/onboarding/presentation/view_model/onboarding_cubit/onboarding_cubit.dart';
import '../../features/trainee_setup/data/data_source/trainee_setup_local_data_source.dart';
import '../../features/trainee_setup/data/data_source/trainee_setup_remote_data_source.dart';
import '../../features/trainee_setup/data/repos/trainee_setup_repo.dart';
import '../../features/trainee_setup/presentation/view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import '../../features/trainee_profile/data/data_source/trainee_profile_remote_data_source.dart';
import '../../features/trainee_profile/data/repos/trainee_profile_repo.dart';
import '../../features/trainee_profile/presentation/view_model/trainee_profile_cubit/trainee_profile_cubit.dart';
import '../../features/trainee_profile/presentation/view_model/training_insights_cubit/training_insights_cubit.dart';
import '../../features/coach_setup/data/data_source/coach_setup_local_data_source.dart';
import '../../features/coach_setup/data/data_source/coach_setup_remote_data_source.dart';
import '../../features/coach_setup/data/repo_impl/coach_setup_repo_impl.dart';
import '../../features/coach_setup/domain/repo/coach_setup_repo.dart';
import '../../features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_cubit.dart';
import '../../features/coach_setup/presentation/view_model/coach_status_cubit/coach_status_cubit.dart';
import '../../features/auth/core/data/repo_impl/auth_session_repo_impl.dart';
import '../../features/auth/core/domain/repo/auth_session_repo.dart';
import '../../features/auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../../features/trainee_discovery/data/data_source/discovery_remote_data_source.dart';
import '../../features/trainee_discovery/data/repos/discovery_repo.dart';
import '../../features/trainee_discovery/presentation/view_model/coach_discovery_cubit/coach_discovery_cubit.dart';
import '../../features/coach_profile_details/data/data_source/coach_profile_details_remote_data_source.dart';
import '../../features/coach_profile_details/data/repos/coach_profile_details_repo.dart';
import '../../features/coach_profile_details/presentation/view_model/coach_profile_details_cubit/coach_profile_details_cubit.dart';
import '../../features/coach_availability/data/data_source/coach_availability_remote_data_source.dart';
import '../../features/coach_availability/data/repos/coach_availability_repo.dart';
import '../../features/coach_availability/presentation/view_model/coach_availability_cubit/coach_availability_cubit.dart';
import '../../features/booking_details/data/data_source/booking_details_remote_data_source.dart';
import '../../features/booking_details/data/repos/booking_details_repo.dart';
import '../../features/booking_details/presentation/view_model/booking_details_cubit/booking_details_cubit.dart';
import '../../features/booking_request/data/data_source/booking_request_remote_data_source.dart';
import '../../features/booking_request/data/repos/booking_request_repo.dart';
import '../../features/booking_request/presentation/view_model/booking_request_cubit/booking_request_cubit.dart';
import '../../features/coach_dashboard/data/data_source/coach_bookings_remote_data_source.dart';
import '../../features/coach_dashboard/data/repos/coach_bookings_repo.dart';
import '../../features/coach_dashboard/presentation/view_model/coach_bookings_cubit/coach_bookings_cubit.dart';
import '../../features/trainee_bookings/data/repos/trainee_bookings_repo.dart';
import '../../features/trainee_bookings/presentation/view_model/trainee_bookings_cubit/trainee_bookings_cubit.dart';
import '../../features/coach_profile/data/data_source/coach_profile_remote_data_source.dart';
import '../../features/coach_profile/data/repos/coach_profile_repo.dart';
import '../../features/coach_profile/presentation/view_model/coach_profile_cubit/coach_profile_cubit.dart';
import '../app_settings/data/repos/app_settings_repo.dart';
import '../app_settings/presentation/view_model/app_settings_cubit/app_settings_cubit.dart';
import '../services/Local_service/general_local_service.dart';
import '../services/auth_service/auth_service.dart';
import '../services/database_service/firestore_service.dart';
import '../services/media_service/media_picker_service.dart';
import '../navigator/auth_route_resolver.dart';
import '../services/storage_service/storage_service.dart';
import '../services/notification_service/notification_service.dart';
import '../../features/notifications/data/data_source/notifications_remote_data_source.dart';
import '../../features/notifications/data/repos/notifications_repo.dart';
import '../../features/notifications/data/helpers/notification_dispatcher.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Core Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<GeneralLocalService>(() => GeneralLocalService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<MediaPickerService>(() => MediaPickerService());
  getIt.registerLazySingleton<NotificationService>(
    () => NotificationService(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<AuthRouteResolver>(
    () => AuthRouteResolver(firestoreService: getIt<FirestoreService>()),
  );

  // 2. Auth Local Data Source
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () =>
        AuthLocalDataSource(generalLocalService: getIt<GeneralLocalService>()),
  );
  await getIt<AuthLocalDataSource>().initHive();

  // 3. Phone Auth Dependencies
  getIt.registerLazySingleton<PhoneAuthRemoteDataSource>(
    () => PhoneAuthRemoteDataSource(
      authService: getIt<AuthService>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<PhoneAuthRepo>(
    () => PhoneAuthRepo(
      remoteDataSource: getIt<PhoneAuthRemoteDataSource>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
      authRouteResolver: getIt<AuthRouteResolver>(),
    ),
  );
  getIt.registerFactory<PhoneAuthCubit>(
    () => PhoneAuthCubit(phoneAuthRepo: getIt<PhoneAuthRepo>()),
  );

  // 6. Choose Role Dependencies
  getIt.registerFactory<ChooseRoleCubit>(
    () => ChooseRoleCubit(
      firestoreService: getIt<FirestoreService>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
      authService: getIt<AuthService>(),
    ),
  );

  // 7. Onboarding Dependencies
  getIt.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSource(
      generalLocalService: getIt<GeneralLocalService>(),
    ),
  );
  getIt.registerFactory<OnboardingCubit>(
    () => OnboardingCubit(
      localDataSource: getIt<OnboardingLocalDataSource>(),
    ),
  );

  // 8. Trainee Setup Dependencies
  getIt.registerLazySingleton<TraineeSetupRemoteDataSource>(
    () => TraineeSetupRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<TraineeSetupLocalDataSource>(
    () => TraineeSetupLocalDataSource(
      generalLocalService: getIt<GeneralLocalService>(),
    ),
  );
  getIt.registerLazySingleton<TraineeSetupRepo>(
    () => TraineeSetupRepo(
      remoteDataSource: getIt<TraineeSetupRemoteDataSource>(),
      localDataSource: getIt<TraineeSetupLocalDataSource>(),
      authService: getIt<AuthService>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<TraineeSetupCubit>(
    () => TraineeSetupCubit(
      repository: getIt<TraineeSetupRepo>(),
    ),
  );

  // 8b. Trainee Profile Dependencies
  getIt.registerLazySingleton<TraineeProfileRemoteDataSource>(
    () => TraineeProfileRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
      storageService: getIt<StorageService>(),
    ),
  );
  getIt.registerLazySingleton<TraineeProfileRepo>(
    () => TraineeProfileRepo(
      remoteDataSource: getIt<TraineeProfileRemoteDataSource>(),
      localDataSource: getIt<TraineeSetupLocalDataSource>(),
      authService: getIt<AuthService>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<TraineeProfileCubit>(
    () => TraineeProfileCubit(
      repository: getIt<TraineeProfileRepo>(),
    ),
  );
  getIt.registerFactory<TrainingInsightsCubit>(
    () => TrainingInsightsCubit(
      repository: getIt<TraineeProfileRepo>(),
    ),
  );

  // 9. Coach Setup Dependencies
  getIt.registerLazySingleton<CoachSetupRemoteDataSource>(
    () => CoachSetupRemoteDataSource(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<CoachSetupLocalDataSource>(
    () => CoachSetupLocalDataSource(generalLocalService: getIt<GeneralLocalService>()),
  );
  getIt.registerLazySingleton<CoachSetupRepo>(
    () => CoachSetupRepoImpl(
      remoteDataSource: getIt<CoachSetupRemoteDataSource>(),
      localDataSource: getIt<CoachSetupLocalDataSource>(),
      authService: getIt<AuthService>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<CoachSetupCubit>(
    () => CoachSetupCubit(repository: getIt<CoachSetupRepo>()),
  );
  getIt.registerFactory<CoachVerificationStatusCubit>(
    () => CoachVerificationStatusCubit(
      repository: getIt<CoachSetupRepo>(),
      authService: getIt<AuthService>(),
    ),
  );


  // 10. Auth Session Dependencies
  getIt.registerLazySingleton<AuthSessionRepo>(
    () => AuthSessionRepoImpl(
      authService: getIt<AuthService>(),
      firestoreService: getIt<FirestoreService>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<AuthSessionCubit>(
    () => AuthSessionCubit(authSessionRepo: getIt<AuthSessionRepo>()),
  );

  // 11. Trainee Discovery Dependencies
  getIt.registerLazySingleton<DiscoveryRemoteDataSource>(
    () => DiscoveryRemoteDataSource(firestoreService: getIt<FirestoreService>()),
  );
  getIt.registerLazySingleton<DiscoveryRepo>(
    () => DiscoveryRepo(remoteDataSource: getIt<DiscoveryRemoteDataSource>()),
  );
  getIt.registerFactory<CoachDiscoveryCubit>(
    () => CoachDiscoveryCubit(repository: getIt<DiscoveryRepo>()),
  );

  // 12. Coach Profile Details Dependencies
  getIt.registerLazySingleton<CoachProfileDetailsRemoteDataSource>(
    () => CoachProfileDetailsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<CoachProfileDetailsRepo>(
    () => CoachProfileDetailsRepo(
      remoteDataSource: getIt<CoachProfileDetailsRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<CoachProfileDetailsCubit>(
    () => CoachProfileDetailsCubit(
      repository: getIt<CoachProfileDetailsRepo>(),
    ),
  );

  // 13. Coach Availability Dependencies
  getIt.registerLazySingleton<CoachAvailabilityRemoteDataSource>(
    () => CoachAvailabilityRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<CoachAvailabilityRepo>(
    () => CoachAvailabilityRepo(
      remoteDataSource: getIt<CoachAvailabilityRemoteDataSource>(),
      localDataSource: getIt<CoachSetupLocalDataSource>(),
    ),
  );
  getIt.registerFactory<CoachAvailabilityCubit>(
    () => CoachAvailabilityCubit(
      repository: getIt<CoachAvailabilityRepo>(),
    ),
  );

  // 14. Booking Request Dependencies
  getIt.registerLazySingleton<BookingRequestRemoteDataSource>(
    () => BookingRequestRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<BookingRequestRepo>(
    () => BookingRequestRepo(
      remoteDataSource: getIt<BookingRequestRemoteDataSource>(),
      authService: getIt<AuthService>(),
      traineeSetupRepo: getIt<TraineeSetupRepo>(),
    ),
  );
  getIt.registerFactory<BookingRequestCubit>(
    () => BookingRequestCubit(
      repository: getIt<BookingRequestRepo>(),
    ),
  );

  // 15. Coach Dashboard Bookings Dependencies
  getIt.registerLazySingleton<CoachBookingsRemoteDataSource>(
    () => CoachBookingsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<CoachBookingsRepo>(
    () => CoachBookingsRepo(
      remoteDataSource: getIt<CoachBookingsRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<CoachBookingsCubit>(
    () => CoachBookingsCubit(
      repository: getIt<CoachBookingsRepo>(),
    ),
  );

  // 16. Trainee Bookings Dependencies
  getIt.registerLazySingleton<TraineeBookingsRepo>(
    () => TraineeBookingsRepo(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerFactory<TraineeBookingsCubit>(
    () => TraineeBookingsCubit(
      repository: getIt<TraineeBookingsRepo>(),
    ),
  );

  // 17. App Settings Dependencies
  getIt.registerLazySingleton<AppSettingsRepo>(
    () => AppSettingsRepo(
      generalLocalService: getIt<GeneralLocalService>(),
    ),
  );
  getIt.registerLazySingleton<AppSettingsCubit>(
    () => AppSettingsCubit(
      repository: getIt<AppSettingsRepo>(),
    ),
  );

  // 18. Coach Profile Dependencies
  getIt.registerLazySingleton<CoachProfileRemoteDataSource>(
    () => CoachProfileRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
      storageService: getIt<StorageService>(),
    ),
  );
  getIt.registerLazySingleton<CoachProfileRepo>(
    () => CoachProfileRepo(
      remoteDataSource: getIt<CoachProfileRemoteDataSource>(),
      localDataSource: getIt<CoachSetupLocalDataSource>(),
      authService: getIt<AuthService>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<CoachProfileCubit>(
    () => CoachProfileCubit(
      repository: getIt<CoachProfileRepo>(),
    ),
  );

  // 19. Booking Details Dependencies
  getIt.registerLazySingleton<BookingDetailsRemoteDataSource>(
    () => BookingDetailsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<BookingDetailsRepo>(
    () => BookingDetailsRepo(
      remoteDataSource: getIt<BookingDetailsRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<BookingDetailsCubit>(
    () => BookingDetailsCubit(
      repository: getIt<BookingDetailsRepo>(),
    ),
  );

  // 20. Notification Dependencies
  getIt.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepository(
      remoteDataSource: getIt<NotificationsRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<NotificationDispatcher>(
    () => NotificationDispatcher(
      repository: getIt<NotificationsRepository>(),
    ),
  );
}

