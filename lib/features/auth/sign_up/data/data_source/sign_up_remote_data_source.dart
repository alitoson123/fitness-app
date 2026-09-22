import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/services/database_service/firestore_service.dart';
import '../../../core/data/models/user_model.dart';

class SignUpRemoteDataSource {
  final AuthService authService;
  final FirestoreService firestoreService;

  SignUpRemoteDataSource({
    required this.authService,
    required this.firestoreService,
  });

  Future<UserModel> signupMethod({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await authService.signUpWithEmail(
      email: email,
      password: password,
    );

    final firebaseUser = credential.user!;
    await firebaseUser.updateDisplayName(name);

    final user = UserModel.fromFirebase(
      user: firebaseUser,
      nameOverride: name,
      role: '',
    );

    await firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: user.uid,
      data: user.toMap(),
    );

    return user;
  }

  Future<void> sendVerificationEmail() async {
    await authService.sendEmailVerification();
  }
}
