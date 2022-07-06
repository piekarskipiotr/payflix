abstract class QrScannerState {
  @override
  String toString() => runtimeType.toString();
}

class ScanningForData extends QrScannerState {}

class CheckingTheFoundData extends QrScannerState {}

class FoundDataIsCorrect extends QrScannerState {}

class FoundDataIsIncorrect extends QrScannerState {}

class UserIsAlreadyInThisGroup extends QrScannerState {}

class UserIsAlreadyInThisVodGroup extends QrScannerState {}

class JoiningGroupCanceled extends QrScannerState {}

class UserCanBeAddedToTheGroup extends QrScannerState {
  final String email;
  final String uid;
  final String groupId;

  UserCanBeAddedToTheGroup(this.email, this.uid, this.groupId);
}

class AddingUserToGroupCompleted extends QrScannerState {}
