abstract class PickingAvatarDialogState {}

class InitPickingAvatarDialogState extends PickingAvatarDialogState {
  @override
  String toString() => runtimeType.toString();
}

class PickingAvatar extends PickingAvatarDialogState {
  @override
  String toString() => runtimeType.toString();
}

class AvatarPicked extends PickingAvatarDialogState {
  final int avatarID;

  AvatarPicked(this.avatarID);

  @override
  String toString() => runtimeType.toString();
}
