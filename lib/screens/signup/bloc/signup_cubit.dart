import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/avatar.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_cubit.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_state.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';

@injectable
class SignUpCubit extends Cubit<SignupState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepo;
  final PickingAvatarDialogCubit _pickingAvatarDialogCubit;
  late StreamSubscription _pickingAvatarDialogCubitSubscription;

  bool _isPasswordObscure = true;
  Avatar? _avatar;
  String? _profileName;
  String? _emailID;
  String? _password;

  SignUpCubit(
      this._authRepo, this._firestoreRepo, this._pickingAvatarDialogCubit)
      : super(InitSignupState()) {
    _pickingAvatarDialogCubitSubscription =
        _pickingAvatarDialogCubit.stream.listen((state) {
      if (state is AvatarPicked) {
        emit(ChangingAvatar());
        _avatar = state.avatar;
        emit(AvatarChanged());
      }
    });
  }

  Avatar? getSelectedAvatar() => _avatar;

  PickingAvatarDialogCubit getDialogCubit() => _pickingAvatarDialogCubit;

  bool isAllFilledUp() => _avatar != null;

  bool isPasswordVisible() => _isPasswordObscure;

  void changePasswordVisibility() {
    emit(ChangingPasswordVisibility());
    _isPasswordObscure = !_isPasswordObscure;
    emit(PasswordVisibilityChanged());
  }

  void saveProfileName(String? profileName) => _profileName = profileName;

  void saveEmailID(String? emailID) => _emailID = emailID;

  void savePassword(String? password) => _password = password;

  Future<void> signUp() async {
    emit(SigningUp());

    try {
      var credential =
          await _authRepo.instance().createUserWithEmailAndPassword(
                email: _emailID!,
                password: _password!,
              );

      var user = credential.user!;

      await _createUserData(user);
      await user.updateDisplayName(_profileName);
      await user.sendEmailVerification();

      emit(SigningUpSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SigningUpFailed(e.code));
    } catch (e) {
      emit(SigningUpFailed(e));
    }
  }

  Future<void> _createUserData(User user) async {
    var deviceToken = await _getDeviceToken();
    var userData = _generateUserData(user, deviceToken);
    if (userData != null) {
      await _firestoreRepo.setUserData(docReference: user.uid, data: userData);
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
        _profileName!,
        List.empty(),
        {},
        [deviceToken],
      );

      return userInfo.toJson();
    } catch (e) {
      SigningUpFailed(e);
    }

    return null;
  }

  @override
  Future<void> close() async {
    await _pickingAvatarDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<SignupState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
