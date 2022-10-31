import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/avatar.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_cubit.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_state.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;
  final PickingAvatarDialogCubit _pickingAvatarDialogBloc;
  late StreamSubscription _pickingAvatarDialogBlocSubscription;

  String? _emailID;
  String? _password;
  Avatar? _avatar;
  bool isSignWithAppleAvailable = false;

  LoginCubit(
    this._authRepo,
    this._firestoreRepository,
    this._pickingAvatarDialogBloc,
  ) : super(InitLoginState()) {
    isSignInWithAppleAvailable();

    _pickingAvatarDialogBlocSubscription =
        _pickingAvatarDialogBloc.stream.listen((state) async {
      if (state is AvatarPicked) {
        emit(PopDialog());

        _avatar = state.avatar;
        final user = _authRepo.instance().currentUser;

        if (user == null) {
          return;
        }

        await _createUserData(user);
        emit(CompletingSigningInFinished());
      }
    });
  }

  PickingAvatarDialogCubit getDialogCubit() => _pickingAvatarDialogBloc;

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

      if (credential.user!.emailVerified) {
        await _onLoggingInSucceeded('form');
      } else {
        emit(NavigateToEmailVerificationRoom());
      }
    } on FirebaseAuthException catch (e) {
      emit(LoggingInFailed(e.code));
    } catch (e) {
      emit(LoggingInFailed(e));
    }
  }

  Future<void> _onLoggingInSucceeded(String loginForm) async {
    var uid = _authRepo.getUID();
    var doesUserHasGroup =
        await _firestoreRepository.doesUserHasAGroup(docReference: uid!);

    switch (loginForm) {
      case 'form':
        emit(LoggingInSucceeded(doesUserHasGroup));
        break;
      case 'google':
        emit(LoggingInWithGoogleAccountSucceeded(doesUserHasGroup));
        break;
      case 'apple':
        emit(LoggingInWithAppleAccountSucceeded(doesUserHasGroup));
        break;
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
        if (!await _firestoreRepository.doesUserExist(docReference: user.uid)) {
          emit(SignInWithGoogleAccountSucceeded());
        } else {
          await _onLoggingInSucceeded('google');
        }
      } else {
        emit(LoggingInWithGoogleAccountCanceled());
      }
    } on FirebaseAuthException catch (e) {
      emit(LoggingInWithGoogleAccountFailed(e.code));
    } catch (e) {
      emit(LoggingInWithGoogleAccountFailed(e));
    }
  }

  Future<void> isSignInWithAppleAvailable() async {
    emit(CheckingSignMethodAvailability());
    isSignWithAppleAvailable = await SignInWithApple.isAvailable();
    emit(CheckingSignMethodAvailabilityCompleted());
  }

  Future<void> authenticateUserByAppleAccount() async {
    emit(LoggingInWithAppleAccount());

    try {
      final appleCredentials = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );


      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        idToken: appleCredentials.identityToken,
        accessToken: appleCredentials.authorizationCode,
      );

      await _authRepo.instance().signInWithCredential(credential);
      var user = _authRepo.instance().currentUser!;
      if (!await _firestoreRepository.doesUserExist(docReference: user.uid)) {
        emit(SignInWithAppleAccountSucceeded());
      } else {
        await _onLoggingInSucceeded('apple');
      }
    } on FirebaseAuthException catch (e) {
      emit(LoggingInWithAppleAccountFailed(e.code));
    } catch (e) {
      emit(LoggingInWithAppleAccountFailed(e));
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
      emit(SendingPasswordResetEmailFailed(e));
    }
  }

  Future<void> _createUserData(User user) async {
    var userId = user.uid;
    var deviceToken = await _getDeviceToken();
    var userData = _generateUserData(user, deviceToken);

    if (userData != null) {
      await _firestoreRepository.setUserData(
        docReference: userId,
        data: userData,
      );
    }
  }

  Future<String?> _getDeviceToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  Map<String, dynamic>? _generateUserData(User user, String? deviceToken) {
    try {
      if (deviceToken == null) {
        throw 'no-device-token';
      }

      var userInfo = PayflixUser(
        user.uid,
        user.email!,
        _avatar!,
        user.displayName ?? 'User',
        List.empty(),
        {},
        deviceToken,
      );

      return userInfo.toJson();
    } catch (e) {
      LoggingInFailed(e);
    }

    return null;
  }

  @override
  void onChange(Change<LoginState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }

  @override
  Future<void> close() {
    _pickingAvatarDialogBlocSubscription.cancel();
    return super.close();
  }
}
