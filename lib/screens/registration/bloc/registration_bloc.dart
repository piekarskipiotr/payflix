import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/registration/bloc/registration_state.dart';

class RegistrationBloc extends Cubit<RegistrationState> {
  bool? _agreementToTermsAndConditions;
  String? _profileName;
  String? _emailId;
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

  Future<void> registerUser() async {
    emit(CreatingUserAccount());

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailId!,
        password: _password!,
      );

      await userCredential.user!.updateDisplayName(_profileName);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email_id': '$_emailId',
        'name': '$_profileName',
        'profile_picture': '',
        'groups_member': {},
        'groups_maintainer': {}
      });

      await userCredential.user!.sendEmailVerification();
      emit(CreatingUserAccountSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(CreatingUserAccountFailed(e.code));
    } catch (e) {
      emit(CreatingUserAccountFailed(e as String?));
    }
  }

  @override
  void onChange(Change<RegistrationState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
