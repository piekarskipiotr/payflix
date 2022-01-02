import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/registration/bloc/registration_state.dart';

class RegistrationBloc extends Cubit<RegistrationState> {
  bool? _agreementToTermsAndConditions;
  String? _profileName;
  String? _emailId;
  String? _password;
  String? _confirmPassword;

  RegistrationBloc() : super(InitRegistrationState());

  bool isTermsAndConditionsAccepted() {
    return _agreementToTermsAndConditions ??= false;
  }

  void changeAgreementOfTermsAndConditions() {
    emit(ChangingAgreementOfTermsAndConditions());
    _agreementToTermsAndConditions = !isTermsAndConditionsAccepted();
    emit(AgreementOfTermsAndConditionsChanged());
  }

  void setProfileName(String? value) {
    _profileName = value;
  }

  void setEmailId(String? value) {
    _emailId = value;
  }

  void setPassword(String? value) {
    _password = value;
  }

  String? getPassword() {
    return _password;
  }

  void setConfirmPassword(String? value) {
    _confirmPassword = value;
  }

  Future<void> registerUser() async {
    log('should start registration procedure with data: {\nProfileName: $_profileName,\nEmailID: $_emailId,\nPassword: $_password,\nConfirmPassword: $_confirmPassword\n}');
  }

  @override
  void onChange(Change<RegistrationState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
