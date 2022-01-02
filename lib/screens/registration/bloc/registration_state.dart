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

