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
  final dynamic error;

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
  final dynamic error;

  LoggingInWithGoogleAccountFailed(this.error);
}

class LoggingInWithGoogleAccountCanceled extends LoginState {}

class LoggingInWithAppleAccount extends LoginState {}

class LoggingInWithAppleAccountSucceeded extends LoginState {
  final bool doesUserHasGroup;

  LoggingInWithAppleAccountSucceeded(this.doesUserHasGroup);
}

class SignInWithAppleAccountSucceeded extends LoginState {}

class LoggingInWithAppleAccountFailed extends LoginState {
  final dynamic error;

  LoggingInWithAppleAccountFailed(this.error);
}

class LoggingInWithAppleAccountCanceled extends LoginState {}

class SendingPasswordResetEmail extends LoginState {}

class SendingPasswordResetEmailSucceeded extends LoginState {}

class SendingPasswordResetEmailFailed extends LoginState {
  final dynamic error;

  SendingPasswordResetEmailFailed(this.error);
}

class CheckingSignMethodAvailability extends LoginState {}

class CheckingSignMethodAvailabilityCompleted extends LoginState {}

class CompletingSigningInFinished extends LoginState {}
