abstract class WelcomeState {}

class InitWelcomeState extends WelcomeState {
  @override
  String toString() => runtimeType.toString();
}

class NavigateToGroup extends WelcomeState {
  @override
  String toString() => runtimeType.toString();
}
