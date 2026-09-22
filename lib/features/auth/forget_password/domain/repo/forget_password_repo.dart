import 'package:dartz/dartz.dart';
import 'package:fitness_app/core/errors/failure.dart';

abstract class ForgetPasswordRepo {
  Future<Either<Failure, void>> forgetPasswordMethod({required String email});
}
