import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/constant/app_constants.dart';
import '../../../../../core/errors/failure.dart';
import '../../../../../core/services/auth_service/auth_service.dart';
import '../../../../../core/services/database_service/firestore_service.dart';
import '../../../../../core/services/logger_service/logger_service.dart';
import '../../domain/repo/auth_session_repo.dart';
import '../data_source/auth_local_data_source.dart';

class AuthSessionRepoImpl implements AuthSessionRepo {
  final AuthService authService;
  final FirestoreService firestoreService;
  final AuthLocalDataSource authLocalDataSource;

  AuthSessionRepoImpl({
    required this.authService,
    required this.firestoreService,
    required this.authLocalDataSource,
  });

  @override
  String? getCurrentUserEmail() {
    return authService.currentUser?.email;
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      LoggerService.info('Initiating sign out', tag: 'AuthSessionRepo');
      await authService.signOut();
      await authLocalDataSource.deleteUser(AppConstants.userBox);
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final uid = authService.currentUser?.uid;
      LoggerService.warning(
        'Initiating account deletion for uid: $uid',
        tag: 'AuthSessionRepo',
      );

      if (uid != null) {
        // Clean up Firestore documents associated with user
        await firestoreService.deleteDoc(
          collection: AppConstants.usersCollection,
          docId: uid,
        );

        await firestoreService.deleteDoc(
          collection: AppConstants.coachProfilesCollection,
          docId: uid,
        );
        await firestoreService.deleteDoc(
          collection: AppConstants.traineeProfilesCollection,
          docId: uid,
        );
        await firestoreService.deleteDoc(
          collection: AppConstants.verificationsCollection,
          docId: uid,
        );
      }

      // Delete user authentication in Firebase
      await authService.deleteAccount();

      // Clean local storage caches
      await authLocalDataSource.deleteUser(AppConstants.userBox);
      await authLocalDataSource.deleteUser(AppConstants.traineeProfileBox);
      await authLocalDataSource.deleteUser(AppConstants.coachProfileBox);

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
