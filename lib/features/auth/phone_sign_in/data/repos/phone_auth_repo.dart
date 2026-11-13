import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/auth_error_messages.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/navigator/app_routes.dart';
import '../../../../../core/navigator/auth_route_resolver.dart';
import '../../../../../core/locator_service/service_locator.dart';
import '../../../../../core/services/notification_service/notification_service.dart';
import '../../../../../core/services/logger_service/logger_service.dart';
import '../../../core/data/data_source/auth_local_data_source.dart';
import '../../../core/data/models/user_model.dart';
import '../data_source/phone_auth_remote_data_source.dart';

class PhoneAuthRepo {
  final PhoneAuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  final AuthRouteResolver _authRouteResolver;

  PhoneAuthRepo({
    required PhoneAuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource authLocalDataSource,
    required AuthRouteResolver authRouteResolver,
  })  : _remoteDataSource = remoteDataSource,
        _authLocalDataSource = authLocalDataSource,
        _authRouteResolver = authRouteResolver;

  /// Sends SMS OTP to the provided E.164 phone number.
  Future<void> sendOtp({
    required String fullPhoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    await _remoteDataSource.sendOtp(
      fullPhoneNumber: fullPhoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      resendToken: resendToken,
    );
  }

  /// Verifies manual 6-digit OTP code and resolves the target route.
  Future<Either<Failure, (UserModel, String)>> verifyOtp({
    required String verificationId,
    required String smsCode,
    required String fullPhoneNumber,
    required String countryCode,
  }) async {
    return _signInAndSync(
      () => _remoteDataSource.signInWithOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      ),
      fullPhoneNumber,
      countryCode,
    );
  }

  /// Handles instant auto-verification on supported Android devices.
  Future<Either<Failure, (UserModel, String)>> handleAutoVerification({
    required AuthCredential credential,
    required String fullPhoneNumber,
    required String countryCode,
  }) async {
    return _signInAndSync(
      () => _remoteDataSource.signInWithCredential(credential),
      fullPhoneNumber,
      countryCode,
    );
  }

  Future<Either<Failure, (UserModel, String)>> _signInAndSync(
    Future<UserCredential> Function() signIn,
    String fullPhoneNumber,
    String countryCode,
  ) async {
    final User? user;
    try {
      user = (await signIn()).user;
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Phone auth sign-in failure: ${e.code}',
        tag: 'PhoneAuthRepo',
      );
      return left(
        ServerFailure(errorMessage: AuthErrorMessages.fromAuthException(e)),
      );
    } catch (e) {
      LoggerService.error('Unexpected phone auth error: $e', tag: 'PhoneAuthRepo');
      return left(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
    }
    if (user == null) {
      return left(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
    }

    try {
      return await _syncUserAndResolveRoute(user, fullPhoneNumber, countryCode);
    } catch (e) {
      // Signed in to Firebase but the user document couldn't be read/created
      // (usually no connection). Sign out again so the user can simply retry
      // instead of being stuck half signed-in.
      LoggerService.error('User sync failed after sign-in: $e', tag: 'PhoneAuthRepo');
      await _signOutQuietly();
      return left(ServerFailure(errorMessage: AuthErrorMessages.connection));
    }
  }

  Future<Either<Failure, (UserModel, String)>> _syncUserAndResolveRoute(
    User user,
    String fullPhoneNumber,
    String countryCode,
  ) async {
    // A different account was cached on this device (e.g. sign-out didn't
    // finish): wipe it so this account never sees the previous one's data.
    final cachedUser = await _authLocalDataSource.getUser();
    if (cachedUser != null && cachedUser.uid != user.uid) {
      await _authLocalDataSource.clearSession();
    }

    var userModel = await _remoteDataSource.getUser(user.uid);

    if (userModel == null) {
      userModel = UserModel(
        uid: user.uid,
        phoneNumber: fullPhoneNumber,
        countryCode: countryCode,
        status: 'active',
      );
      await _remoteDataSource.saveUser(userModel);
    }

    final String targetRoute;
    try {
      targetRoute = await _authRouteResolver.resolveTargetRoute(
        uid: userModel.uid,
        role: userModel.role,
      );
    } on AuthAccessDeniedException catch (e) {
      // Suspended or admin account: don't keep it signed in on this device.
      LoggerService.warning(
        'Sign-in blocked: ${e.reason}',
        tag: 'PhoneAuthRepo',
      );
      await _signOutQuietly();
      return left(
        ServerFailure(errorMessage: AuthErrorMessages.fromAccessDenied(e.reason)),
      );
    } catch (e) {
      // Signed in, but the route couldn't be read (e.g. connection dropped).
      // Save the session and let the splash screen resolve it with a retry.
      LoggerService.warning(
        'Route resolution failed after sign-in: $e',
        tag: 'PhoneAuthRepo',
      );
      await _authLocalDataSource.saveUser(user: userModel);
      return right((userModel, AppRoutes.splash));
    }

    await _authLocalDataSource.saveUser(user: userModel);
    getIt<NotificationService>().syncFcmToken(
      userModel.uid,
      role: userModel.role,
    );
    return right((userModel, targetRoute));
  }

  Future<void> _signOutQuietly() async {
    try {
      await _remoteDataSource.signOut();
    } catch (e) {
      LoggerService.warning('Sign out failed: $e', tag: 'PhoneAuthRepo');
    }
    await _authLocalDataSource.clearSession();
  }
}
