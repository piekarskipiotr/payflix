abstract class RegistrationState {

}

class InitRegistrationState extends RegistrationState {
  @override
  String toString() => runtimeType.toString();
}

class ChangingAgreementOfTermsAndConditions extends RegistrationState {
  @override
  String toString() => runtimeType.toString();
}

class AgreementOfTermsAndConditionsChanged extends RegistrationState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingUserAccount extends RegistrationState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingUserAccountSucceeded extends RegistrationState {
  @override
  String toString() => runtimeType.toString();
}

class CreatingUserAccountFailed extends RegistrationState {
  final String? errorCode;
  CreatingUserAccountFailed(this.errorCode);

  @override
  String toString() => runtimeType.toString();
}

