import 'package:fitness_app/core/errors/failure.dart';
import 'package:fitness_app/core/navigator/auth_route_resolver.dart';
import 'package:fitness_app/core/services/auth_service/auth_service.dart';
import 'package:fitness_app/features/auth/sign_in/data/repo_impl/sign_in_repo_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_in_states.dart';

class SignInCubit extends Cubit<SignInStates> {
  final SignInRepoImpl signInRepoImpl;
  final AuthService authService;
  final AuthRouteResolver authRouteResolver;

  SignInCubit({
    required this.signInRepoImpl,
    required this.authService,
    required this.authRouteResolver,
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

    await result.fold(
      (failure) async => emit(SignInErrorState(errMessage: failure.errorMessage)),
      (user) async {
        final isVerified = await authService.reloadAndCheckEmailVerified();
        if (!isVerified) {
          emit(SignInEmailNotVerifiedState());
        } else {
          final targetRoute = await authRouteResolver.resolveTargetRoute(
            uid: user.uid,
            role: user.role,
          );
          emit(SignInSuccessState(user: user, targetRoute: targetRoute));
        }
      },
    );
  }

  Future<void> signInWithGoogleMethod() async {
    emit(SignInLoadingState());
    final result = await signInRepoImpl.signInWithGoogleMethod();

    await result.fold(
      (failure) async {
        if (failure is CancelFailure) {
          emit(SignInInitialState());
        } else {
          emit(SignInErrorState(errMessage: failure.errorMessage));
        }
      },
      (user) async {
        final targetRoute = await authRouteResolver.resolveTargetRoute(
          uid: user.uid,
          role: user.role,
        );
        emit(SignInSuccessState(user: user, targetRoute: targetRoute));
      },
    );
  }

  Future<void> signInWithAppleMethod() async {
    emit(SignInLoadingState());
    final result = await signInRepoImpl.signInWithAppleMethod();

    await result.fold(
      (failure) async {
        if (failure is CancelFailure) {
          emit(SignInInitialState());
        } else {
          emit(SignInErrorState(errMessage: failure.errorMessage));
        }
      },
      (user) async {
        final targetRoute = await authRouteResolver.resolveTargetRoute(
          uid: user.uid,
          role: user.role,
        );
        emit(SignInSuccessState(user: user, targetRoute: targetRoute));
      },
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
