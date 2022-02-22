import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';

class SignUpCubit extends Cubit<SignupState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  bool _tcppStatus = false;
  String? _profileName;
  String? _emailID;
  String? _password;

  SignUpCubit(this._firebaseAuth, this._firebaseFirestore)
      : super(InitSignupState());

  bool isTCPPAccepted() {
    return _tcppStatus;
  }

  void changeTCPPStatus() {
    emit(ChangingTCPPStatus());
    _tcppStatus = !_tcppStatus;
    emit(TCPPStatusChanged());
  }

  void saveProfileName(String? profileName) => _profileName = profileName;

  void saveEmailID(String? emailID) => _emailID = emailID;

  void savePassword(String? password) => _password = password;

  Future<void> signUp() async {
    emit(SigningUp());

    try {
      var credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailID!,
        password: _password!,
      );

      await credential.user!.updateDisplayName(_profileName);
      await credential.user!.sendEmailVerification();
      emit(SigningUpSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SigningUpFailed(e.code));
    } catch (e) {
      emit(SigningUpFailed(e as String?));
    }
  }

  @override
  void onChange(Change<SignupState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
