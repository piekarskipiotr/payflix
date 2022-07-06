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

class ReceivingLink extends LaunchingScreenState {}

class AddingUserToGroup extends LaunchingScreenState {}

class UserIsAlreadyInThisGroup extends LaunchingScreenState {}

class UserIsAlreadyInThisVodGroup extends LaunchingScreenState {}

class AddingUserToGroupCompleted extends LaunchingScreenState {}

class JoiningGroupCanceled extends LaunchingScreenState {}

class UserCanBeAddedToTheGroup extends LaunchingScreenState {
  final String email;
  final String uid;
  final String groupId;

  UserCanBeAddedToTheGroup(this.email, this.uid, this.groupId);
}
