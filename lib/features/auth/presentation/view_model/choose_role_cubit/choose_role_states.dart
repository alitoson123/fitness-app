abstract class ChooseRoleStates {}

class ChooseRoleInitialState extends ChooseRoleStates {}

class ChooseRoleLoadingState extends ChooseRoleStates {}

class ChooseRoleSuccessState extends ChooseRoleStates {
  final String role;
  ChooseRoleSuccessState({required this.role});
}

class ChooseRoleErrorState extends ChooseRoleStates {
  final String errMessage;
  ChooseRoleErrorState({required this.errMessage});
}
