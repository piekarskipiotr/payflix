abstract class LoginState {

}

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
  final String? errorCode;
  LoggingInFailed(this.errorCode);

  @override
  String toString() => runtimeType.toString();
}

class NavigateToWaitingRoom extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccount extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccountCanceled extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccountSucceeded extends LoginState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingInWithGoogleAccountFailed extends LoginState {
  final String? errorCode;
  LoggingInWithGoogleAccountFailed(this.errorCode);

  @override
  String toString() => runtimeType.toString();
}
