import 'package:payflix/data/model/payflix_user.dart';

abstract class MembersState {
  @override
  String toString() => runtimeType.toString();
}

class InitMembersState extends MembersState {}

class InitializingMembers extends MembersState {}

class FetchingMembers extends MembersState {}

class FetchingMembersSucceeded extends MembersState {
  final List<PayflixUser> members;

  FetchingMembersSucceeded(this.members);
}

class FetchingMembersFailed extends MembersState {}

class RefreshingData extends MembersState {}
