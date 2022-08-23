abstract class SignupState {
  @override
  String toString() => runtimeType.toString();
}

class InitSignupState extends SignupState {}

// TCPP -> Terms and Conditions and Privacy Policy
class ChangingTCPPStatus extends SignupState {}

class TCPPStatusChanged extends SignupState {}

class ChangingAvatar extends SignupState {}

class AvatarChanged extends SignupState {}

class SigningUp extends SignupState {}

class SigningUpSucceeded extends SignupState {}

class SigningUpFailed extends SignupState {
  final dynamic error;

  SigningUpFailed(this.error);
}
