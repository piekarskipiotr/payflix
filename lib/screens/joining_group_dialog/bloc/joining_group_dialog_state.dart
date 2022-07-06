abstract class JoiningGroupDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitJoiningGroupDialogState extends JoiningGroupDialogState {}

class JoiningToGroup extends JoiningGroupDialogState {}

class JoiningToGroupSucceeded extends JoiningGroupDialogState {}

class JoiningToGroupCanceled extends JoiningGroupDialogState {}