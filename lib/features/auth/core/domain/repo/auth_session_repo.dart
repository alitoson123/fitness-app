import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failure.dart';

abstract class AuthSessionRepo {
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> deleteAccount();
  String? getCurrentUserEmail();
}
