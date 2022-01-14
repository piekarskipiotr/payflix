abstract class JoinGroupRoomState {

}

class InitJoinGroupRoomState extends JoinGroupRoomState {
  @override
  String toString() => runtimeType.toString();
}

class JoiningTheGroup extends JoinGroupRoomState {
  @override
  String toString() => runtimeType.toString();
}

class JoiningTheGroupSucceeded extends JoinGroupRoomState {
  @override
  String toString() => runtimeType.toString();
}

class JoiningTheGroupFailed extends JoinGroupRoomState {
  @override
  String toString() => runtimeType.toString();
}