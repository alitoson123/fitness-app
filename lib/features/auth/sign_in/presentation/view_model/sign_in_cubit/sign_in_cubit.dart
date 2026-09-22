import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/auth/sign_in/data/repo_impl/sign_in_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_in_states.dart';

class SignInCubit extends Cubit<SignInStates> {
  final SignInRepoImpl signInRepoImpl;
  final AuthService authService;

  SignInCubit({
    required this.signInRepoImpl,
    required this.authService,
  }) : super(SignInInitialState());

  Future<void> signInMethod({
    required String email,
    required String password,
  }) async {
    emit(SignInLoadingState());
    final result = await signInRepoImpl.signInMethod(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(SignInErrorState(errMessage: failure.errorMessage)),
      (user) async {
        final isVerified = await authService.reloadAndCheckEmailVerified();
        if (!isVerified) {
          emit(SignInEmailNotVerifiedState());
        } else {
          emit(SignInSuccessState(user: user));
        }
      },
    );
  }

  Future<void> signInWithGoogleMethod() async {
    emit(SignInLoadingState());
    final result = await signInRepoImpl.signInWithGoogleMethod();

    result.fold(
      (failure) {
        if (failure is CancelFailure) {
          emit(SignInInitialState());
        } else {
          emit(SignInErrorState(errMessage: failure.errorMessage));
        }
      },
      (user) => emit(SignInSuccessState(user: user)),
    );
  }

  Future<void> signInWithAppleMethod() async {
    emit(SignInLoadingState());
    final result = await signInRepoImpl.signInWithAppleMethod();

    result.fold(
      (failure) {
        if (failure is CancelFailure) {
          emit(SignInInitialState());
        } else {
          emit(SignInErrorState(errMessage: failure.errorMessage));
        }
      },
      (user) => emit(SignInSuccessState(user: user)),
    );
  }

  Future<void> resendVerificationEmail() async {
    try {
      await authService.sendEmailVerification();
      emit(SignInVerificationEmailSentState());
    } catch (e) {
      emit(SignInErrorState(errMessage: e.toString()));
    }
  }
}
