import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import '../../generated/l10n.dart';

/// A short, translated message for an unexpected error. Raw exception text
/// (`e.toString()`, Firebase messages, ids) is never shown to users.
abstract class AppErrorMessages {
  static const _connectionCodes = {
    'unavailable',
    'deadline-exceeded',
    'network-request-failed',
  };

  static String get unexpected => S.current.unexpectedErrorMessage;

  static String from(Object error) {
    if (error is SocketException ||
        (error is FirebaseException && _connectionCodes.contains(error.code))) {
      return S.current.connectionErrorMessage;
    }
    return S.current.unexpectedErrorMessage;
  }
}
