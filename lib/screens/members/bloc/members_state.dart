abstract class MembersState {}

class InitMembersState extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingMembers extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingMembersSucceeded extends MembersState {
  final List<String> members;

  FetchingMembersSucceeded(this.members);

  @override
  String toString() => runtimeType.toString();
}

class FetchingMembersFailed extends MembersState {
  @override
  String toString() => runtimeType.toString();
}