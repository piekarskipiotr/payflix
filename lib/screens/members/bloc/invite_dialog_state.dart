abstract class InviteDialogState {}

class InitInviteDialogState extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class ChangingDialogView extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class DialogViewChanged extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class ChangingCopiedTextVisibility extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class CopiedTextVisibilityChanged extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class GettingInviteLink extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class GettingInviteLinkSucceeded extends InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}
