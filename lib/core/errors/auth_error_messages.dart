import 'package:firebase_auth/firebase_auth.dart';
import '../../generated/l10n.dart';
import '../navigator/auth_route_resolver.dart';

/// Localized, user-facing messages for the sign-in / account flows.
/// Raw Firebase messages and `e.toString()` are never shown to users.
abstract class AuthErrorMessages {
  static String fromAuthException(FirebaseAuthException e) {
    final s = S.current;
    switch (e.code) {
      case 'invalid-verification-code':
      case 'invalid-verification-id':
      case 'session-expired':
      case 'code-expired':
      case 'invalid-credential':
        return s.otpIncorrectOrExpired;
      case 'invalid-phone-number':
        return s.invalidPhoneFormat;
      case 'too-many-requests':
      case 'quota-exceeded':
        return s.tooManyAttemptsMessage;
      case 'network-request-failed':
        return s.connectionErrorMessage;
      case 'user-disabled':
        return s.accountSuspendedMessage;
      default:
        return s.unexpectedErrorMessage;
    }
  }

  static String fromAccessDenied(AuthAccessDeniedReason reason) {
    switch (reason) {
      case AuthAccessDeniedReason.suspended:
        return S.current.accountSuspendedMessage;
      case AuthAccessDeniedReason.adminAccount:
        return S.current.adminUseDashboardMessage;
    }
  }

  static String get unexpected => S.current.unexpectedErrorMessage;
  static String get connection => S.current.connectionErrorMessage;
}
