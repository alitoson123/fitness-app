import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseFailureHelper {
  // firebase exception
  static String mapFirebaseException(FirebaseException exception) {
    switch (exception.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'The service is currently unavailable. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'not-found':
        return 'The requested resource was not found.';
      case 'already-exists':
        return 'This resource already exists.';
      case 'unauthenticated':
        return 'You must be logged in to perform this action.';
      default:
        return exception.message ?? 'Unknown error occurred, please try again later.';
    }
  }
// auth exception
  static String mapAuthException(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'invalid-credential':
        return 'The credentials provided are invalid or expired.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'requires-recent-login':
        return 'Please log in again to perform this action.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'credential-already-in-use':
        return 'This credential is already linked to another account.';
      default:
        return exception.message ?? 'Authentication error occurred, please try again.';
    }
  }
}
