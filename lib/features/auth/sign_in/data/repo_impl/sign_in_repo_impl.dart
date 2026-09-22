import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../../core/errors/failure.dart';
import '../../../core/data/data_source/auth_local_data_source.dart';
import '../../../core/data/models/user_model.dart';
import '../data_source/sign_in_remote_data_source.dart';
import '../../domain/repo/sign_in_repo.dart';

class SignInRepoImpl extends SignInRepo {
  final SignInRemoteDataSource signInRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  SignInRepoImpl({
    required this.signInRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> signInMethod({
    required String email,
    required String password,
  }) async {
    try {
      final user = await signInRemoteDataSource.signInMethod(
        email: email,
        password: password,
      );
      await authLocalDataSource.saveUser(user: user);
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogleMethod() async {
    try {
      final user = await signInRemoteDataSource.signInWithGoogleMethod();
      if (user == null) {
        return left(CancelFailure());
      }
      await authLocalDataSource.saveUser(user: user);
      return right(user);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithAppleMethod() async {
    try {
      final user = await signInRemoteDataSource.signInWithAppleMethod();
      if (user == null) {
        return left(CancelFailure());
      }
      await authLocalDataSource.saveUser(user: user);
      return right(user);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return left(CancelFailure());
      }
      return left(ServerFailure(errorMessage: e.message));
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
