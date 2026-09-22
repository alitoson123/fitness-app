import 'package:get_it/get_it.dart';
import '../../features/auth/core/data/data_source/auth_local_data_source.dart';
import '../../features/auth/forget_password/data/data_source/forget_password_remote_data_source.dart';
import '../../features/auth/forget_password/data/repo_impl/forget_password_repo_impl.dart';
import '../../features/auth/forget_password/presentation/view_model/forget_password_cubit/forget_password_cubit.dart';
import '../../features/auth/presentation/view_model/choose_role_cubit/choose_role_cubit.dart';
import '../../features/auth/sign_in/data/data_source/sign_in_remote_data_source.dart';
import '../../features/auth/sign_in/data/repo_impl/sign_in_repo_impl.dart';
import '../../features/auth/sign_in/presentation/view_model/sign_in_cubit/sign_in_cubit.dart';
import '../../features/auth/sign_up/data/data_source/sign_up_remote_data_source.dart';
import '../../features/auth/sign_up/data/repo_impl/sign_up_repo_impl.dart';
import '../../features/auth/sign_up/presentation/view_model/sign_up_cubit/sign_up_cubit.dart';
import '../services/Local_service/general_local_service.dart';
import '../services/auth_service/auth_service.dart';
import '../services/database_service/firestore_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // 1. Core Services
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirestoreService>(() => FirestoreService());
  getIt.registerLazySingleton<GeneralLocalService>(() => GeneralLocalService());

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
}
