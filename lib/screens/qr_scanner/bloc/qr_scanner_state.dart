abstract class QrScannerState {
  @override
  String toString() => runtimeType.toString();
}

class ScanningForData extends QrScannerState {}

class CheckingTheFoundData extends QrScannerState {}

class FoundDataIsCorrect extends QrScannerState {}

class FoundDataIsIncorrect extends QrScannerState {}

class AddingUserToGroup extends QrScannerState {}

class UserIsAlreadyInThisGroup extends QrScannerState {}

class UserIsAlreadyInThisVodGroup extends QrScannerState {}

class AddingUserToGroupCompleted extends QrScannerState {}