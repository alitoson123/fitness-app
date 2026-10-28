import 'package:firebase_auth/firebase_auth.dart';
import '../../services/logger_service/logger_service.dart';

/// Service wrapping Firebase Authentication with focus on Phone Number Auth.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  /// Initiates SMS phone number verification for Egypt & Lebanon.
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? resendToken,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    LoggerService.info(
      'Verifying phone number: $phoneNumber',
      tag: 'AuthService',
    );
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      forceResendingToken: resendToken,
      timeout: timeout,
    );
  }

  /// Signs in using a 6-digit SMS code and the verification ID received.
  Future<UserCredential> signInWithOtpCredential({
    required String verificationId,
    required String smsCode,
  }) async {
    LoggerService.info('Signing in with OTP code', tag: 'AuthService');
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  /// Signs in using an already verified PhoneAuthCredential (auto-retrieval).
  Future<UserCredential> signInWithCredential(
    AuthCredential credential,
  ) async {
    LoggerService.info(
      'Signing in with pre-verified credential',
      tag: 'AuthService',
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    LoggerService.info('Signing out current user', tag: 'AuthService');
    await _firebaseAuth.signOut();
  }

  /// Permanently deletes the current user account from Firebase Auth.
  Future<void> deleteAccount() async {
    LoggerService.warning('Deleting current user account', tag: 'AuthService');
    await _firebaseAuth.currentUser?.delete();
  }
}