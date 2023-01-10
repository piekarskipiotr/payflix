abstract class SignupState {
  @override
  String toString() => runtimeType.toString();
}

class InitSignupState extends SignupState {}

class ChangingPasswordVisibility extends SignupState {}

class PasswordVisibilityChanged extends SignupState {}

class ChangingAvatar extends SignupState {}

class AvatarChanged extends SignupState {}

class SigningUp extends SignupState {}

class SigningUpSucceeded extends SignupState {}

class SigningUpFailed extends SignupState {
  final dynamic error;

  SigningUpFailed(this.error);
}
