abstract class ChangePasswordDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitChangePasswordDialogState extends ChangePasswordDialogState {}

class ChangingPasswordVisibility extends ChangePasswordDialogState {}

class PasswordVisibilityChanged extends ChangePasswordDialogState {}

class ChangingUserPassword extends ChangePasswordDialogState {}

class ChangingUserPasswordSucceeded extends ChangePasswordDialogState {}

class ChangingUserPasswordFailed extends ChangePasswordDialogState {
  final String error;

  ChangingUserPasswordFailed(this.error);
}
