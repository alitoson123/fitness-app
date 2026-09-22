import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';
import '../../../core/data/models/user_model.dart';

abstract class SignUpRepo {
  Future<Either<Failure, UserModel>> signupMethod({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> sendVerificationEmail();
}
