abstract class CreateGroupState {}

class InitCreateGroupState extends CreateGroupState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingGroup extends CreateGroupState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingGroupSucceeded extends CreateGroupState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingGroupFailed extends CreateGroupState {
  @override
  String toString() => runtimeType.toString();
}
