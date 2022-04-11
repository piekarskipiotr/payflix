import 'dart:ui';

abstract class SignupState {}

class InitSignupState extends SignupState {
  @override
  String toString() => runtimeType.toString();
}

// TCPP -> Terms and Conditions and Privacy Policy
class ChangingTCPPStatus extends SignupState {
  @override
  String toString() => runtimeType.toString();
}

class TCPPStatusChanged extends SignupState {
  @override
  String toString() => runtimeType.toString();
}

class ChangingAvatar extends SignupState {
  @override
  String toString() => runtimeType.toString();
}

class AvatarChanged extends SignupState {
  final String avatar;
  final Color color;

  AvatarChanged(this.avatar, this.color);

  @override
  String toString() => runtimeType.toString();
}

class SigningUp extends SignupState {
  @override
  String toString() => runtimeType.toString();
}

class SigningUpSucceeded extends SignupState {
  @override
  String toString() => runtimeType.toString();
}

class SigningUpFailed extends SignupState {
  final String? error;

  SigningUpFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}