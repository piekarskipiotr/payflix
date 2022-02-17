import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  String? _emailID;
  String? _password;

  LoginCubit() : super(InitLoginState());

  void saveEmailID(String? emailID) {
    _emailID = emailID;
  }

  void savePassword(String? password) {
    _password = password;
  }

  String? getEmailID() => _emailID;

  Future<void> authenticateUserByForm() async {
    emit(LoggingIn());
    try {
      var credential =
      await getIt<FirebaseAuth>().signInWithEmailAndPassword(
        email: _emailID!,
        password: _password!,
      );

      emit(credential.user!.emailVerified ? LoggingInSucceeded() : NavigateToEmailVerificationRoom());
    } on FirebaseAuthException catch (e) {
      emit(LoggingInFailed(e.code));
    } catch (e) {
      emit(LoggingInFailed(e as String?));
    }
  }

  Future<void> authenticateUserByGoogleAccount() async {
    emit(LoggingInWithGoogleAccount());

    try {
      var googleSignInAccount = await GoogleSignIn().signIn();
      if (googleSignInAccount != null) {
        var googleSignInAuth = await googleSignInAccount.authentication;

        var credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuth.accessToken,
          idToken: googleSignInAuth.idToken,
        );

        await getIt<FirebaseAuth>().signInWithCredential(credential);
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

  Future<void> restartPassword() async {
    emit(SendingPasswordResetEmail());
    try {
      await getIt<FirebaseAuth>().sendPasswordResetEmail(email: _emailID!);
      emit(SendingPasswordResetEmailSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SendingPasswordResetEmailFailed(e.code));
    } catch (e) {
      emit(SendingPasswordResetEmailFailed(e as String?));
    }
  }

  @override
  void onChange(Change<LoginState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
