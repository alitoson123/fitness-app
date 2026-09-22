import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/errors/failure.dart';
import '../../../core/data/data_source/auth_local_data_source.dart';
import '../../../core/data/models/user_model.dart';
import '../data_source/sign_up_remote_data_source.dart';
import '../../domain/repo/sign_up_repo.dart';

class SignUpRepoImpl extends SignUpRepo {
  final SignUpRemoteDataSource signUpRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  SignUpRepoImpl({
    required this.signUpRemoteDataSource,
    required this.authLocalDataSource,
  });

  @override
  Future<Either<Failure, UserModel>> signupMethod({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await signUpRemoteDataSource.signupMethod(
        name: name,
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
  Future<Either<Failure, void>> sendVerificationEmail() async {
    try {
      await signUpRemoteDataSource.sendVerificationEmail();
      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(ServerFailure.fromFirebaseAuthError(e));
    } catch (e) {
      return left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
