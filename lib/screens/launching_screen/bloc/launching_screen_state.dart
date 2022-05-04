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

class HandlingLink extends LaunchingScreenState {
  final Uri link;

  HandlingLink(this.link);

  @override
  String toString() => runtimeType.toString();
}

class HoldingLink extends LaunchingScreenState {
  final Uri link;

  HoldingLink(this.link);

  @override
  String toString() => runtimeType.toString();
}