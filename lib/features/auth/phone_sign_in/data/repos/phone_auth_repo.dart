import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/navigator/auth_route_resolver.dart';
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
    try {
      final credential = await _remoteDataSource.signInWithOtp(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final user = credential.user;
      if (user == null) {
        return left(ServerFailure(errorMessage: 'Authentication failed.'));
      }
      return await _syncUserAndResolveRoute(user, fullPhoneNumber, countryCode);
    } on FirebaseAuthException catch (e) {
      LoggerService.error(
        'Phone auth OTP failure: ${e.code}',
        tag: 'PhoneAuthRepo',
      );
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      LoggerService.error(
        'Unexpected phone auth error: $e',
        tag: 'PhoneAuthRepo',
      );
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  /// Handles instant auto-verification on supported Android devices.
  Future<Either<Failure, (UserModel, String)>> handleAutoVerification({
    required AuthCredential credential,
    required String fullPhoneNumber,
    required String countryCode,
  }) async {
    try {
      final userCredential =
          await _remoteDataSource.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) {
        return left(ServerFailure(errorMessage: 'Auto-verification failed.'));
      }
      return await _syncUserAndResolveRoute(user, fullPhoneNumber, countryCode);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, (UserModel, String)>> _syncUserAndResolveRoute(
    User user,
    String fullPhoneNumber,
    String countryCode,
  ) async {
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

    await _authLocalDataSource.saveUser(user: userModel);
    final targetRoute = await _authRouteResolver.resolveTargetRoute(
      uid: userModel.uid,
      role: userModel.role,
    );
    return right((userModel, targetRoute));
  }
}
