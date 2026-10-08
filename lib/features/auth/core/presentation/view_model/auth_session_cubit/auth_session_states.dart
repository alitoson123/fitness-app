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

class AuthSessionErrorState extends AuthSessionStates {
  final String errorMessage;
  const AuthSessionErrorState({required this.errorMessage});
}
