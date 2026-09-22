import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/core/services/logger_service/logger_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
  bool get isLoggedIn => _firebaseAuth.currentUser != null;

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    LoggerService.info('Signing up user with email: $email', tag: 'AuthService');
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    LoggerService.info('Signing in user with email: $email', tag: 'AuthService');
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    LoggerService.info('Sending password reset email to: $email', tag: 'AuthService');
    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

 /* Future<UserCredential?> signInWithGoogle() async {
    LoggerService.info('Initiating Google Sign In', tag: 'AuthService');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // If the user cancels sign-in
    if (googleUser == null) return null;

    // Obtain authentication details
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential,
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }
*/
  Future<UserCredential?> signInWithApple() async {
    LoggerService.info('Initiating Apple Sign In', tag: 'AuthService');
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
    final AuthCredential credential = oAuthProvider.credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser?.sendEmailVerification();
  }

  Future<bool> reloadAndCheckEmailVerified() async {
    await _firebaseAuth.currentUser?.reload();
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  Future<void> signOut() async {
    LoggerService.info('Signing out current user', tag: 'AuthService');
    try {
      //await GoogleSignIn().signOut();
    } catch (_) {}
    await _firebaseAuth.signOut();
  }

  Future<void> deleteAccount() async {
    LoggerService.warning('Deleting current user account', tag: 'AuthService');
    await _firebaseAuth.currentUser?.delete();
  }
}