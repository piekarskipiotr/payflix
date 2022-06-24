abstract class GroupSettingsState {
  @override
  String toString() => runtimeType.toString();
}

class InitGroupSettingsState extends GroupSettingsState {}

class SavingSettings extends GroupSettingsState {}

class SavingSettingsSucceeded extends GroupSettingsState {}

class SavingSettingsFailed extends GroupSettingsState {
  final String? error;

  SavingSettingsFailed(this.error);
}

class CreatingGroup extends GroupSettingsState {}

class CreatingGroupSucceeded extends GroupSettingsState {}

class CreatingGroupFailed extends GroupSettingsState {
  final String? error;

  CreatingGroupFailed(this.error);
}

class ChangingPasswordVisibility extends GroupSettingsState {}

class PasswordVisibilityChanged extends GroupSettingsState {}

class ChangingVod extends GroupSettingsState {}

class VodChanged extends GroupSettingsState {}
