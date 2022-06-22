abstract class EditProfileDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitEditProfileDialogState extends EditProfileDialogState {}

class UserDataSameAsPrevious extends EditProfileDialogState {}

class SavingUserProfileChanges extends EditProfileDialogState {}

class SavingUserProfileChangesSucceeded extends EditProfileDialogState {}

class SavingUserProfileChangesFailed extends EditProfileDialogState {
  final String error;

  SavingUserProfileChangesFailed(this.error);
}

class ChangingAvatar extends EditProfileDialogState {}

class AvatarChanged extends EditProfileDialogState {}
