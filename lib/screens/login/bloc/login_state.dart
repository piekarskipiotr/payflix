abstract class LoginState {
  @override
  String toString() => runtimeType.toString();
}

class InitLoginState extends LoginState {}

class PopDialog extends LoginState {}

class LoggingIn extends LoginState {}

class LoggingInSucceeded extends LoginState {
  final bool doesUserHasGroup;

  LoggingInSucceeded(this.doesUserHasGroup);
}

class LoggingInFailed extends LoginState {
  final String? error;

  LoggingInFailed(this.error);
}

class NavigateToEmailVerificationRoom extends LoginState {}

class LoggingInWithGoogleAccount extends LoginState {}

class LoggingInWithGoogleAccountSucceeded extends LoginState {
  final bool doesUserHasGroup;

  LoggingInWithGoogleAccountSucceeded(this.doesUserHasGroup);
}

class SignInWithGoogleAccountSucceeded extends LoginState {}

class LoggingInWithGoogleAccountFailed extends LoginState {
  final String? error;

  LoggingInWithGoogleAccountFailed(this.error);
}

class LoggingInWithGoogleAccountCanceled extends LoginState {}

class SendingPasswordResetEmail extends LoginState {}

class SendingPasswordResetEmailSucceeded extends LoginState {}

class SendingPasswordResetEmailFailed extends LoginState {
  final String? error;

  SendingPasswordResetEmailFailed(this.error);
}
