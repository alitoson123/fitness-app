import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/auth_error_messages.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/services/logger_service/logger_service.dart';
import '../../../../../core/services/notification_service/notification_service.dart';
import '../../domain/repo/auth_session_repo.dart';
import '../data_source/auth_local_data_source.dart';

class AuthSessionRepoImpl implements AuthSessionRepo {
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;
  final NotificationService? notificationService;

  AuthSessionRepoImpl({
    required this.authService,
    required this.authLocalDataSource,
    this.notificationService,
  });

  @override
  String? getCurrentUserPhoneNumber() => authService.currentUser?.phoneNumber;

  @override
  Future<Either<Failure, void>> signOut() async {
    LoggerService.info('Initiating sign out', tag: 'AuthSessionRepo');
    final uid = authService.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      try {
        await notificationService?.detachFcmToken(uid);
      } catch (e) {
        // Never block sign-out on token cleanup (e.g. offline).
        LoggerService.warning(
          'FCM token detach failed during sign out: $e',
          tag: 'AuthSessionRepo',
        );
      }
    }

    Failure? failure;
    try {
      await authService.signOut();
    } on FirebaseAuthException catch (e) {
      failure = ServerFailure(errorMessage: AuthErrorMessages.fromAuthException(e));
    } catch (e) {
      LoggerService.error('Sign out failed: $e', tag: 'AuthSessionRepo');
      failure = ServerFailure(errorMessage: AuthErrorMessages.unexpected);
    }

    // Always wipe local account data, even if Firebase sign-out failed, so the
    // next account on this device never sees this account's cached data.
    await authLocalDataSource.clearSession();
    return failure == null ? right(null) : left(failure);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    final uid = authService.currentUser?.uid;
    LoggerService.warning(
      'Initiating account deletion for uid: $uid',
      tag: 'AuthSessionRepo',
    );
    if (uid == null) {
      return left(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
    }

    try {
      // The login is deleted FIRST. If Firebase refuses (old sign-in), nothing
      // has been removed yet and the user can confirm with an SMS code.
      // Firestore/Storage data is then removed server-side by the
      // `onAuthUserDeleted` Cloud Function.
      await authService.deleteAccount();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return left(
          ReauthRequiredFailure(errorMessage: AuthErrorMessages.unexpected),
        );
      }
      return left(
        ServerFailure(errorMessage: AuthErrorMessages.fromAuthException(e)),
      );
    } catch (e) {
      LoggerService.error('Account deletion failed: $e', tag: 'AuthSessionRepo');
      return left(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
    }

    await authLocalDataSource.clearSession();
    return right(null);
  }

  @override
  Future<void> sendReauthCode({
    required void Function(String verificationId) onCodeSent,
    required void Function(AuthCredential credential) onAutoVerified,
    required void Function(Failure failure) onFailed,
  }) async {
    final phone = authService.currentUser?.phoneNumber;
    if (phone == null || phone.isEmpty) {
      onFailed(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
      return;
    }
    try {
      await authService.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: onAutoVerified,
        verificationFailed: (e) => onFailed(
          ServerFailure(errorMessage: AuthErrorMessages.fromAuthException(e)),
        ),
        codeSent: (verificationId, _) => onCodeSent(verificationId),
        codeAutoRetrievalTimeout: (_) {},
      );
    } on FirebaseAuthException catch (e) {
      onFailed(
        ServerFailure(errorMessage: AuthErrorMessages.fromAuthException(e)),
      );
    } catch (e) {
      LoggerService.error('Reauth SMS failed: $e', tag: 'AuthSessionRepo');
      onFailed(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
    }
  }

  @override
  Future<Either<Failure, void>> reauthenticateAndDelete(
    AuthCredential credential,
  ) async {
    try {
      await authService.reauthenticate(credential);
    } on FirebaseAuthException catch (e) {
      return left(
        ServerFailure(errorMessage: AuthErrorMessages.fromAuthException(e)),
      );
    } catch (e) {
      LoggerService.error('Reauthentication failed: $e', tag: 'AuthSessionRepo');
      return left(ServerFailure(errorMessage: AuthErrorMessages.unexpected));
    }
    return deleteAccount();
  }
}
