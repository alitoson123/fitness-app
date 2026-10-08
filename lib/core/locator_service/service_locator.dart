import 'package:get_it/get_it.dart';
import '../../features/auth/core/data/data_source/auth_local_data_source.dart';
import '../../features/auth/forget_password/data/data_source/forget_password_remote_data_source.dart';
import '../../features/auth/forget_password/data/repo_impl/forget_password_repo_impl.dart';
import '../../features/auth/forget_password/presentation/view_model/forget_password_cubit/forget_password_cubit.dart';
import '../../features/auth/choose_role/presentation/view_model/choose_role_cubit/choose_role_cubit.dart';
import '../../features/auth/sign_in/data/data_source/sign_in_remote_data_source.dart';
import '../../features/auth/sign_in/data/repo_impl/sign_in_repo_impl.dart';
import '../../features/auth/sign_in/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import '../../features/auth/sign_up/data/data_source/sign_up_remote_data_source.dart';
import '../../features/auth/sign_up/data/repo_impl/sign_up_repo_impl.dart';
import '../../features/auth/sign_up/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';
import '../../features/onboarding/data/data_source/onboarding_local_data_source.dart';
import '../../features/onboarding/presentation/view_model/onboarding_cubit/onboarding_cubit.dart';
import '../../features/trainee_setup/data/data_source/trainee_setup_local_data_source.dart';
import '../../features/trainee_setup/data/data_source/trainee_setup_remote_data_source.dart';
import '../../features/trainee_setup/data/repos/trainee_setup_repo.dart';
import '../../features/trainee_setup/presentation/view_model/trainee_setup_cubit/trainee_setup_cubit.dart';
import '../../features/coach_setup/data/data_source/coach_setup_local_data_source.dart';
import '../../features/coach_setup/data/data_source/coach_setup_remote_data_source.dart';
import '../../features/coach_setup/data/repo_impl/coach_setup_repo_impl.dart';
import '../../features/coach_setup/domain/repo/coach_setup_repo.dart';
import '../../features/coach_setup/presentation/view_model/coach_setup_cubit/coach_setup_cubit.dart';
import '../../features/coach_setup/presentation/view_model/coach_status_cubit/coach_status_cubit.dart';
import '../../features/auth/core/data/repo_impl/auth_session_repo_impl.dart';
import '../../features/auth/core/domain/repo/auth_session_repo.dart';
import '../../features/auth/core/presentation/view_model/auth_session_cubit/auth_session_cubit.dart';
import '../services/Local_service/general_local_service.dart';
import '../services/auth_service/auth_service.dart';
import '../services/database_service/firestore_service.dart';
import '../services/media_service/media_picker_service.dart';
import '../navigator/auth_route_resolver.dart';
import '../services/storage_service/storage_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Core Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<GeneralLocalService>(() => GeneralLocalService());
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<MediaPickerService>(() => MediaPickerService());
  getIt.registerLazySingleton<AuthRouteResolver>(
    () => AuthRouteResolver(firestoreService: getIt<FirestoreService>()),
  );

  // 2. Auth Local Data Source
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () =>
        AuthLocalDataSource(generalLocalService: getIt<GeneralLocalService>()),
  );
  await getIt<AuthLocalDataSource>().initHive();

  // 3. Sign In Dependencies
  getIt.registerLazySingleton<SignInRemoteDataSource>(
    () => SignInRemoteDataSource(
      authService: getIt<AuthService>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<SignInRepoImpl>(
    () => SignInRepoImpl(
      signInRemoteDataSource: getIt<SignInRemoteDataSource>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<SignInCubit>(
    () => SignInCubit(
      signInRepoImpl: getIt<SignInRepoImpl>(),
      authService: getIt<AuthService>(),
      authRouteResolver: getIt<AuthRouteResolver>(),
    ),
  );

  // 4. Sign Up Dependencies
  getIt.registerLazySingleton<SignUpRemoteDataSource>(
    () => SignUpRemoteDataSource(
      authService: getIt<AuthService>(),
      firestoreService: getIt<FirestoreService>(),
    ),
  );
  getIt.registerLazySingleton<SignUpRepoImpl>(
    () => SignUpRepoImpl(
      signUpRemoteDataSource: getIt<SignUpRemoteDataSource>(),
      authLocalDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerFactory<SignUpCubit>(
    () => SignUpCubit(signUpRepoImpl: getIt<SignUpRepoImpl>()),
  );

  // 5. Forget Password Dependencies
  getIt.registerLazySingleton<ForgetPasswordRemoteDataSource>(
    () => ForgetPasswordRemoteDataSource(authService: getIt<AuthService>()),
  );
  getIt.registerLazySingleton<ForgetPasswordRepoImpl>(
    () => ForgetPasswordRepoImpl(
      forgetPasswordRemoteDataSource: getIt<ForgetPasswordRemoteDataSource>(),
    ),
  );
  getIt.registerFactory<ForgetPasswordCubit>(
    () => ForgetPasswordCubit(
      forgetPasswordRepo: getIt<ForgetPasswordRepoImpl>(),
    ),
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
  getIt.registerFactory<CoachStatusCubit>(
    () => CoachStatusCubit(
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
}

