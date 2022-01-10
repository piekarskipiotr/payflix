abstract class EmailVerifyWaitingRoomState {}

class InitEmailVerifyWaitingRoomState extends EmailVerifyWaitingRoomState {
  @override
  String toString() => runtimeType.toString();
}

class SendingVerificationEmail extends EmailVerifyWaitingRoomState {
  @override
  String toString() => runtimeType.toString();
}

class SendingVerificationEmailSucceeded extends EmailVerifyWaitingRoomState {
  @override
  String toString() => runtimeType.toString();
}

class SendingVerificationEmailFailed extends EmailVerifyWaitingRoomState {
  @override
  String toString() => runtimeType.toString();
}
