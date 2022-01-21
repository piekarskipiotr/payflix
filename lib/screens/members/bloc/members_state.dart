abstract class MembersState {}

class InitMembersState extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class LoadingMembers extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class LoadingMembersSucceeded extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class LoadingMembersFailed extends MembersState {
  @override
  String toString() => runtimeType.toString();
}
