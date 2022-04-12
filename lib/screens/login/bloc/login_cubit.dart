import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  String? _emailID;
  String? _password;

  LoginCubit(this._authRepo, this._firestoreRepository) : super(InitLoginState());

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
      var credential = await _authRepo.instance().signInWithEmailAndPassword(
            email: _emailID!,
            password: _password!,
          );

      emit(credential.user!.emailVerified
          ? LoggingInSucceeded()
          : NavigateToEmailVerificationRoom());
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

        await _authRepo.instance().signInWithCredential(credential);

        var user = _authRepo.instance().currentUser!;
        await _createUserData(user);

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
      await _authRepo.instance().sendPasswordResetEmail(email: _emailID!);
      emit(SendingPasswordResetEmailSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SendingPasswordResetEmailFailed(e.code));
    } catch (e) {
      emit(SendingPasswordResetEmailFailed(e as String?));
    }
  }

  Future<void> _createUserData(User user) async {
    var userId = user.uid;
    var userData = _generateUserData(user);

    await _firestoreRepository.setUserData(docReference: userId, data: userData);
  }

  Map<String, dynamic> _generateUserData(User user) {
    var userInfo = PayflixUser(
      user.uid,
      0,
      user.displayName!,
      List.empty(),
    );

    return userInfo.toJson();
  }

  @override
  void onChange(Change<LoginState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
