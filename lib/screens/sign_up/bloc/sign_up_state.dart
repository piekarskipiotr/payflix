abstract class SignUpState {}

class InitSignUpState extends SignUpState {
  @override
  String toString() => runtimeType.toString();
}

// TCPP -> Terms and Conditions and Privacy Policy
class ChangingTCPPStatus extends SignUpState {
  @override
  String toString() => runtimeType.toString();
}

class TCPPStatusChanged extends SignUpState {
  @override
  String toString() => runtimeType.toString();
}

class SigningUp extends SignUpState {
  @override
  String toString() => runtimeType.toString();
}

class SigningUpSucceeded extends SignUpState {
  @override
  String toString() => runtimeType.toString();
}

class SigningUpFailed extends SignUpState {
  final String? error;

  SigningUpFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}