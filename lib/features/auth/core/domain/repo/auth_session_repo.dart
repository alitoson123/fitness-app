import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/failure.dart';

abstract class AuthSessionRepo {
  /// Signs out of Firebase and wipes every account-specific local cache.
  Future<Either<Failure, void>> signOut();

  /// Deletes the Firebase login. Returns [ReauthRequiredFailure] when Firebase
  /// needs a fresh SMS confirmation first; in that case nothing is deleted.
  /// The account's server data is removed by the `onAuthUserDeleted`
  /// Cloud Function once the login is gone.
  Future<Either<Failure, void>> deleteAccount();

  /// Sends an SMS code to the signed-in user's own phone number so they can
  /// confirm their identity before deleting the account.
  Future<void> sendReauthCode({
    required void Function(String verificationId) onCodeSent,
    required void Function(AuthCredential credential) onAutoVerified,
    required void Function(Failure failure) onFailed,
  });

  /// Confirms identity with [credential], then deletes the account.
  Future<Either<Failure, void>> reauthenticateAndDelete(
    AuthCredential credential,
  );

  String? getCurrentUserPhoneNumber();
}
