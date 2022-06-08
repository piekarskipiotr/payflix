abstract class LaunchingScreenState {}

class InitLaunchingScreenState extends LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}

class StartingApp extends LaunchingScreenState {
  final String route;

  StartingApp(this.route);

  @override
  String toString() => runtimeType.toString();
}

class CheckingUserData extends LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}

class ReceivingLink extends LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}

class AddingUserToGroup extends LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}

class UserIsAlreadyInThisGroup extends LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}

class AddingUserToGroupCompleted extends LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}