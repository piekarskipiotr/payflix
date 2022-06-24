abstract class PickingAvatarDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitPickingAvatarDialogState extends PickingAvatarDialogState {}

class PickingAvatar extends PickingAvatarDialogState {}

class AvatarPicked extends PickingAvatarDialogState {
  final int avatarID;

  AvatarPicked(this.avatarID);
}
