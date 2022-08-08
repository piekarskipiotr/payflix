abstract class AppListenerState {
  @override
  String toString() => runtimeType.toString();
}

class InitAppListenerState extends AppListenerState {}

class AlreadyInGroup extends AppListenerState {}

class AlreadyInThisVodGroup extends AppListenerState {}

class DisplayingJoinDialog extends AppListenerState {
  final String email;
  final String uid;
  final String groupId;

  DisplayingJoinDialog(this.email, this.uid, this.groupId);
}

class AddingUserToGroupSucceeded extends AppListenerState {}

class AddingUserToGroupCanceled extends AppListenerState {}