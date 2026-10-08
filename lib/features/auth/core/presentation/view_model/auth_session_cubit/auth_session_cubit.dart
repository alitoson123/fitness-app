import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repo/auth_session_repo.dart';
import 'auth_session_states.dart';

class AuthSessionCubit extends Cubit<AuthSessionStates> {
  final AuthSessionRepo authSessionRepo;

  AuthSessionCubit({required this.authSessionRepo})
      : super(const AuthSessionInitialState());

  String? get currentUserEmail => authSessionRepo.getCurrentUserEmail();

  Future<void> signOut() async {
    emit(const AuthSessionLoadingState(isDeleting: false));
    final result = await authSessionRepo.signOut();
    result.fold(
      (failure) => emit(AuthSessionErrorState(errorMessage: failure.errorMessage)),
      (_) => emit(const AuthSessionSignOutSuccessState()),
    );
  }

  Future<void> deleteAccount() async {
    emit(const AuthSessionLoadingState(isDeleting: true));
    final result = await authSessionRepo.deleteAccount();
    result.fold(
      (failure) => emit(AuthSessionErrorState(errorMessage: failure.errorMessage)),
      (_) => emit(const AuthSessionDeleteSuccessState()),
    );
  }
}
