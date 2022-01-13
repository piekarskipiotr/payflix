import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  String? _emailId;
  String? _password;
  bool _validatePassword = true;

  LoginBloc() : super(InitLoginState());

  void clearSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  Future<void> restartPassword() async {
    emit(SendingPasswordResetEmail());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailId!);
      emit(SendingPasswordResetEmailSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SendingPasswordResetEmailFailed(e.code));
    } catch (e) {
      emit(SendingPasswordResetEmailFailed(e as String?));
    }
  }

  void changePasswordVerificationStatus() {
    _validatePassword = !_validatePassword;
  }

  bool shouldIValidatePasswordFiled() {
    return _validatePassword;
  }

  void setEmailId(String? value) {
    _emailId = value;
  }

  void setPassword(String? value) {
    _password = value;
  }

  Future<void> authenticateUserByForm() async {
    emit(LoggingIn());
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailId!,
        password: _password!,
      );

      emit(userCredential.user!.emailVerified
          ? LoggingInSucceeded()
          : NavigateToWaitingRoom());
    } on FirebaseAuthException catch (e) {
      emit(LoggingInFailed(e.code));
    } catch (e) {
      emit(LoggingInFailed(e as String?));
    }
  }

  Future<void> authenticateUserByGoogleAccount() async {
    emit(LoggingInWithGoogleAccount());

    try {
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await FirebaseAuth.instance.signInWithCredential(credential);
        emit(LoggingInWithGoogleAccountSucceeded());
      } else {
        emit(LoggingInWithGoogleAccountCanceled());
      }
    } on FirebaseAuthException catch (e) {
      emit(LoggingInWithGoogleAccountFailed(e.code));
    } catch (e) {
      emit(LoggingInWithGoogleAccountFailed(e as String?));
    }
  }

  Future<void> authenticateUserByAppleAccount() async {
    // TODO: try to login user by apple account
    log('should start apple logging procedure');
  }

  @override
  void onChange(Change<LoginState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
