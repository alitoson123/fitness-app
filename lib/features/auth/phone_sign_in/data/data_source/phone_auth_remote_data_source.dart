import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/services/database_service/firestore_service.dart';
import '../../../../../core/services/logger_service/logger_service.dart';
import '../../../core/data/models/user_model.dart';

class PhoneAuthRemoteDataSource {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  PhoneAuthRemoteDataSource({
    required AuthService authService,
    required FirestoreService firestoreService,
  })  : _authService = authService,
        _firestoreService = firestoreService;

  Future<void> sendOtp({
    required String fullPhoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
    int? resendToken,
  }) async {
    LoggerService.info(
      'Sending OTP to $fullPhoneNumber',
      tag: 'PhoneAuthRemote',
    );
    await _authService.verifyPhoneNumber(
      phoneNumber: fullPhoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      resendToken: resendToken,
    );
  }

  Future<UserCredential> signInWithOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    LoggerService.info(
      'Signing in with OTP credential',
      tag: 'PhoneAuthRemote',
    );
    return await _authService.signInWithOtpCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  Future<UserCredential> signInWithCredential(
    AuthCredential credential,
  ) async {
    LoggerService.info(
      'Signing in with pre-verified credential',
      tag: 'PhoneAuthRemote',
    );
    return await _authService.signInWithCredential(credential);
  }

  Future<UserModel?> getUser(String uid) async {
    LoggerService.debug(
      'Fetching user document for $uid',
      tag: 'PhoneAuthRemote',
    );
    final doc = await _firestoreService.getDoc(
      collection: AppConstants.usersCollection,
      docId: uid,
    );
    if (doc.exists && doc.data() != null) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> saveUser(UserModel user) async {
    LoggerService.info(
      'Saving user document for ${user.uid}',
      tag: 'PhoneAuthRemote',
    );
    await _firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: user.uid,
      data: user.toMap(),
    );
  }
}

