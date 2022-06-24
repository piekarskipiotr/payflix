abstract class VerRoomState {
  @override
  String toString() => runtimeType.toString();
}

class InitVerRoomState extends VerRoomState {}

class ResendingVerificationEmail extends VerRoomState {}

class ResendingVerificationEmailSucceeded extends VerRoomState {}

class ResendingVerificationEmailFailed extends VerRoomState {
  String? error;

  ResendingVerificationEmailFailed(this.error);
}

class EmailVerificationSucceeded extends VerRoomState {}

class LoggingOut extends VerRoomState {}

class LoggingOutFinished extends VerRoomState {}
