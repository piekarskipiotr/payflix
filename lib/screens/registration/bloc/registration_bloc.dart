import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/registration/bloc/registration_state.dart';

class RegistrationBloc extends Cubit<RegistrationState> {
  bool? _agreementToTermsAndConditions;
  String? _password;

  RegistrationBloc() : super(InitRegistrationState());

  bool isTermsAndConditionsAccepted() {
    return _agreementToTermsAndConditions ??= false;
  }

  void changeAgreementOfTermsAndConditions() {
    emit(ChangingAgreementOfTermsAndConditions());
    _agreementToTermsAndConditions = !isTermsAndConditionsAccepted();
    emit(AgreementOfTermsAndConditionsChanged());
  }

  void setPassword(String? value) {
    _password = value;
  }

  String? getPassword() {
    return _password;
  }

  Future<void> registerUser() async {
    log('should start registration procedure');
  }

  @override
  void onChange(Change<RegistrationState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}