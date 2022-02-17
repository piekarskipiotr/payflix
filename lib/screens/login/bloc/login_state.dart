abstract class LoginState {}

class InitLoginState extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingIn extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInSucceeded extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInFailed extends LoginState {
  final String? error;

  LoggingInFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}

class NavigateToEmailVerificationRoom extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccount extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccountSucceeded extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccountFailed extends LoginState {
  final String? error;

  LoggingInWithGoogleAccountFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccountCanceled extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class SendingPasswordResetEmail extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class SendingPasswordResetEmailSucceeded extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class SendingPasswordResetEmailFailed extends LoginState {
  final String? error;

  SendingPasswordResetEmailFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}