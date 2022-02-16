import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/screens/sign_up/bloc/sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  bool _tcppStatus = false;
  String? _profileName;
  String? _emailID;
  String? _password;

  SignUpCubit() : super(InitSignUpState());

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
      var credential =
          await getIt<FirebaseAuth>().createUserWithEmailAndPassword(
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
  void onChange(Change<SignUpState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
