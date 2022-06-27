import 'package:payflix/data/model/avatar.dart';

abstract class PickingAvatarDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitPickingAvatarDialogState extends PickingAvatarDialogState {}

class FetchingAvatars extends PickingAvatarDialogState {}

class AvatarsFetched extends PickingAvatarDialogState {}

class PickingAvatar extends PickingAvatarDialogState {}

class AvatarPicked extends PickingAvatarDialogState {
  final Avatar avatar;

  AvatarPicked(this.avatar);
}
