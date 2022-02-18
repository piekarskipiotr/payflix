abstract class VerRoomState {}

class InitVerRoomState extends VerRoomState {
  @override
  String toString() => runtimeType.toString();
}

class ResendingVerificationEmail extends VerRoomState {
  @override
  String toString() => runtimeType.toString();
}

class ResendingVerificationEmailSucceeded extends VerRoomState {
  @override
  String toString() => runtimeType.toString();
}

class ResendingVerificationEmailFailed extends VerRoomState {
  String? error;

  ResendingVerificationEmailFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}

class EmailVerificationSucceeded extends VerRoomState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingOut extends VerRoomState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingOutFinished extends VerRoomState {
  @override
  String toString() => runtimeType.toString();
}
