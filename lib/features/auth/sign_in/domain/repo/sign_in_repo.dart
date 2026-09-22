import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../core/data/models/user_model.dart';

abstract class SignInRepo {
  Future<Either<Failure, UserModel>> signInMethod({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> signInWithGoogleMethod();

  Future<Either<Failure, UserModel>> signInWithAppleMethod();
}
