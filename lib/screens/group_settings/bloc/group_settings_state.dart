abstract class GroupSettingsState {}

class InitGroupSettingsState extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingGroup extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingGroupSucceeded extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingGroupFailed extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}
