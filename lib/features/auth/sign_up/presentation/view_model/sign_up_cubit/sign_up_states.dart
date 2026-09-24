import 'package:fitness_app/features/auth/core/data/models/user_model.dart';

abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

class SignUpSuccessState extends SignUpStates {
  final UserModel user;
  final String email;
  final String password;

  SignUpSuccessState({
    required this.user,
    required this.email,
    required this.password,
  });
}

class SignUpErrorState extends SignUpStates {
  final String errMessage;
  SignUpErrorState({required this.errMessage});
}
