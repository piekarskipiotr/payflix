abstract class GroupQuickActionsDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitGroupQuickActionsDialogState extends GroupQuickActionsDialogState {}

class ChangingDialogView extends GroupQuickActionsDialogState {}

class DialogViewChanged extends GroupQuickActionsDialogState {}

class LeavingGroup extends GroupQuickActionsDialogState {}

class LeavingGroupSucceeded extends GroupQuickActionsDialogState {}

class LeavingGroupFailed extends GroupQuickActionsDialogState {}

class ChangingCopiedTextVisibility extends GroupQuickActionsDialogState {}

class CopiedTextVisibilityChanged extends GroupQuickActionsDialogState {}

class ChangingPasswordVisibility extends GroupQuickActionsDialogState {}

class PasswordVisibilityChanged extends GroupQuickActionsDialogState {}
