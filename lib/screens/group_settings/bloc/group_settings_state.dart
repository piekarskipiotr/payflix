abstract class GroupSettingsState {}

class InitGroupSettingsState extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class SavingSettings extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class SavingSettingsSucceeded extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class SavingSettingsFailed extends GroupSettingsState {
  final String? error;

  SavingSettingsFailed(this.error);

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
  final String? error;

  CreatingGroupFailed(this.error);

  @override
  String toString() => runtimeType.toString();
}

class ChangingPasswordVisibility extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class PasswordVisibilityChanged extends GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}