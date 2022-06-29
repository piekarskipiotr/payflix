abstract class InviteDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitInviteDialogState extends InviteDialogState {}

class ChangingDialogView extends InviteDialogState {}

class DialogViewChanged extends InviteDialogState {}

class ChangingCopiedTextVisibility extends InviteDialogState {}

class CopiedTextVisibilityChanged extends InviteDialogState {}

class GettingInviteLink extends InviteDialogState {}

class GettingInviteLinkSucceeded extends InviteDialogState {}

class SharingQrCode extends InviteDialogState {}

class SharingQrCodeFinished extends InviteDialogState {}
