abstract class GroupDeleteState {
  @override
  String toString() => runtimeType.toString();
}

class InitGroupDeleteState extends GroupDeleteState {}

class DeletingGroup extends GroupDeleteState {}

class DeletingGroupSucceeded extends GroupDeleteState {}

class DeletingGroupFailed extends GroupDeleteState {
  dynamic error;

  DeletingGroupFailed(this.error);
}
