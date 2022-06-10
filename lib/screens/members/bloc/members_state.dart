import 'package:payflix/data/model/payflix_user.dart';

abstract class MembersState {}

class InitMembersState extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class InitializingGroup extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingMembers extends MembersState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingMembersSucceeded extends MembersState {
  final List<PayflixUser> members;

  FetchingMembersSucceeded(this.members);

  @override
  String toString() => runtimeType.toString();
}

class FetchingMembersFailed extends MembersState {
  @override
  String toString() => runtimeType.toString();
}
