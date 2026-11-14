import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_failure.dart';

abstract class Failure {
  final String errorMessage;
  Failure({required this.errorMessage});
}

class ServerFailure extends Failure {
  ServerFailure({required super.errorMessage});

  // firebase exception
  factory ServerFailure.fromFirebaseError(FirebaseException firebaseException) {
    return ServerFailure(
      errorMessage: FirebaseFailureHelper.mapFirebaseException(
        firebaseException,
      ),
    );
  }

  // firebase auth exception
  factory ServerFailure.fromFirebaseAuthError(
    FirebaseAuthException authException,
  ) {
    return ServerFailure(
      errorMessage: FirebaseFailureHelper.mapAuthException(authException),
    );
  }
}

/// The coach's profile is gone or no longer approved, so they can't be
/// booked.
class CoachUnavailableFailure extends Failure {
  CoachUnavailableFailure({required super.errorMessage});
}

class CancelFailure extends Failure {
  CancelFailure({super.errorMessage = 'Operation cancelled'});
}

/// Firebase refused a sensitive action (e.g. deleting the account) because
/// the sign-in is too old. The user must confirm with a fresh SMS code.
class ReauthRequiredFailure extends Failure {
  ReauthRequiredFailure({required super.errorMessage});
}
