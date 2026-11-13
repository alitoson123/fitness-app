abstract class AuthSessionStates {
  const AuthSessionStates();
}

class AuthSessionInitialState extends AuthSessionStates {
  const AuthSessionInitialState();
}

class AuthSessionLoadingState extends AuthSessionStates {
  final bool isDeleting;
  const AuthSessionLoadingState({this.isDeleting = false});
}

class AuthSessionSignOutSuccessState extends AuthSessionStates {
  const AuthSessionSignOutSuccessState();
}

class AuthSessionDeleteSuccessState extends AuthSessionStates {
  const AuthSessionDeleteSuccessState();
}

/// Firebase needs a fresh SMS confirmation before deleting the account.
/// Nothing has been deleted yet; the UI opens the confirmation dialog.
class AuthSessionReauthRequiredState extends AuthSessionStates {
  const AuthSessionReauthRequiredState();
}

/// Progress of the SMS confirmation that precedes account deletion.
class AuthSessionReauthState extends AuthSessionStates {
  final bool isSendingCode;
  final bool isVerifying;
  final String? verificationId;
  final String? errorMessage;

  const AuthSessionReauthState({
    this.isSendingCode = false,
    this.isVerifying = false,
    this.verificationId,
    this.errorMessage,
  });
}

class AuthSessionErrorState extends AuthSessionStates {
  final String errorMessage;
  const AuthSessionErrorState({required this.errorMessage});
}
