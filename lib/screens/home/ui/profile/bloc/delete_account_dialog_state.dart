abstract class DeleteAccountDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitDeleteAccountDialogState extends DeleteAccountDialogState {}

class DeletingAccount extends DeleteAccountDialogState {}

class DeletingAccountSucceeded extends DeleteAccountDialogState {}

class DeletingAccountFailed extends DeleteAccountDialogState {
  dynamic error;

  DeletingAccountFailed(this.error);
}
