abstract class LaunchingScreenState {
  @override
  String toString() => runtimeType.toString();
}

class InitLaunchingScreenState extends LaunchingScreenState {}

class StartingApp extends LaunchingScreenState {
  final String route;

  StartingApp(this.route);
}

class InitializingApp extends LaunchingScreenState {}
