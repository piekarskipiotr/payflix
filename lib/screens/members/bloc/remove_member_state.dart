import 'package:payflix/data/model/group.dart';

abstract class RemoveMemberState {
  @override
  String toString() => runtimeType.toString();
}

class InitRemoveMemberState extends RemoveMemberState {}

class RemovingMember extends RemoveMemberState {}

class RemovingMemberSucceeded extends RemoveMemberState {
  final Group group;

  RemovingMemberSucceeded(this.group);
}

class RemovingMemberFailed extends RemoveMemberState {
  final dynamic error;

  RemovingMemberFailed(this.error);
}
