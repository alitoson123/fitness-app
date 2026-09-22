import 'package:fitness_app/features/auth/sign_up/data/repo_impl/sign_up_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_up_states.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  final SignUpRepoImpl signUpRepoImpl;

  SignUpCubit({required this.signUpRepoImpl}) : super(SignUpInitialState());

  Future<void> signUpMethod({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignUpLoadingState());
    final result = await signUpRepoImpl.signupMethod(
      name: name,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(SignUpErrorState(errMessage: failure.errorMessage)),
      (user) async {
        await signUpRepoImpl.sendVerificationEmail();
        emit(SignUpSuccessState(user: user));
      },
    );
  }
}
