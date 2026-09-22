import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/services/database_service/firestore_service.dart';
import '../../../core/data/models/user_model.dart';

class SignInRemoteDataSource {
  final AuthService authService;
  final FirestoreService firestoreService;

  SignInRemoteDataSource({
    required this.authService,
    required this.firestoreService,
  });

  Future<UserModel> signInMethod({
    required String email,
    required String password,
  }) async {
    final credential = await authService.signInWithEmail(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    
    final docSnapshot = await firestoreService.getDoc(
      collection: AppConstants.usersCollection,
      docId: uid,
    );

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return UserModel.fromJson(docSnapshot.data()!);
    }

    final fallbackUser = UserModel.fromFirebase(user: credential.user!);
    await firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: uid,
      data: fallbackUser.toMap(),
    );
    return fallbackUser;
  }

  Future<UserModel?> signInWithGoogleMethod() async {
    final credential = await authService.signInWithApple();
    if (credential == null || credential.user == null) {
      return null;
    }

    final user = credential.user!;
    final docSnapshot = await firestoreService.getDoc(
      collection: AppConstants.usersCollection,
      docId: user.uid,
    );

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return UserModel.fromJson(docSnapshot.data()!);
    }

    final newUser = UserModel.fromFirebase(user: user);
    await firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: user.uid,
      data: newUser.toMap(),
    );
    return newUser;
  }

  Future<UserModel?> signInWithAppleMethod() async {
    final credential = await authService.signInWithApple();
    if (credential == null || credential.user == null) {
      return null;
    }

    final user = credential.user!;
    final docSnapshot = await firestoreService.getDoc(
      collection: AppConstants.usersCollection,
      docId: user.uid,
    );

    if (docSnapshot.exists && docSnapshot.data() != null) {
      return UserModel.fromJson(docSnapshot.data()!);
    }

    final newUser = UserModel.fromFirebase(user: user);
    await firestoreService.setData(
      collection: AppConstants.usersCollection,
      docId: user.uid,
      data: newUser.toMap(),
    );
    return newUser;
  }
}
