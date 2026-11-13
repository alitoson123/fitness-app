import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../domain/repo/auth_session_repo.dart';
import 'auth_session_states.dart';

class AuthSessionCubit extends Cubit<AuthSessionStates> {
  final AuthSessionRepo authSessionRepo;

  AuthSessionCubit({required this.authSessionRepo})
      : super(const AuthSessionInitialState());

  String? get currentUserPhoneNumber =>
      authSessionRepo.getCurrentUserPhoneNumber();

  void _emitSafe(AuthSessionStates state) {
    if (!isClosed) emit(state);
  }

  Future<void> signOut() async {
    _emitSafe(const AuthSessionLoadingState(isDeleting: false));
    final result = await authSessionRepo.signOut();
    result.fold(
      (failure) =>
          _emitSafe(AuthSessionErrorState(errorMessage: failure.errorMessage)),
      (_) => _emitSafe(const AuthSessionSignOutSuccessState()),
    );
  }

  Future<void> deleteAccount() async {
    _emitSafe(const AuthSessionLoadingState(isDeleting: true));
    final result = await authSessionRepo.deleteAccount();
    _handleDeleteResult(result.fold((f) => f, (_) => null));
  }

  /// Sends the SMS code used to confirm identity before deletion.
  Future<void> sendReauthCode() async {
    _emitSafe(const AuthSessionReauthState(isSendingCode: true));
    await authSessionRepo.sendReauthCode(
      onCodeSent: (verificationId) =>
          _emitSafe(AuthSessionReauthState(verificationId: verificationId)),
      onAutoVerified: (credential) => _confirmWithCredential(credential),
      onFailed: (failure) => _emitSafe(
        AuthSessionReauthState(errorMessage: failure.errorMessage),
      ),
    );
  }

  /// Confirms identity with the typed SMS code, then deletes the account.
  Future<void> confirmReauthAndDelete(String smsCode) async {
    final current = state;
    final verificationId =
        current is AuthSessionReauthState ? current.verificationId : null;
    if (verificationId == null) return;
    await _confirmWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.trim(),
      ),
      verificationId: verificationId,
    );
  }

  Future<void> _confirmWithCredential(
    AuthCredential credential, {
    String? verificationId,
  }) async {
    final current = state;
    if (current is AuthSessionReauthState && current.isVerifying) return;
    final vid = verificationId ??
        (current is AuthSessionReauthState ? current.verificationId : null);
    _emitSafe(AuthSessionReauthState(isVerifying: true, verificationId: vid));
    final result = await authSessionRepo.reauthenticateAndDelete(credential);
    result.fold(
      (failure) => _emitSafe(
        AuthSessionReauthState(
          verificationId: vid,
          errorMessage: failure.errorMessage,
        ),
      ),
      (_) => _emitSafe(const AuthSessionDeleteSuccessState()),
    );
  }

  void _handleDeleteResult(Failure? failure) {
    if (failure == null) {
      _emitSafe(const AuthSessionDeleteSuccessState());
    } else if (failure is ReauthRequiredFailure) {
      _emitSafe(const AuthSessionReauthRequiredState());
    } else {
      _emitSafe(AuthSessionErrorState(errorMessage: failure.errorMessage));
    }
  }

  /// The user closed the confirmation dialog without finishing.
  void cancelReauth() => _emitSafe(const AuthSessionInitialState());
}
