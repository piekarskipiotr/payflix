import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool _tcppStatus = false;
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

  bool isTCPPAccepted() => _tcppStatus;

  bool isAllFilledUp() => _tcppStatus && (_avatar != null);

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
      emit(SigningUpFailed(e as String?));
    }
  }

  Future<void> _createUserData(User user) async {
    var userData = _generateUserData(user);
    await _firestoreRepo.setUserData(docReference: user.uid, data: userData);
  }

  Map<String, dynamic> _generateUserData(User user) {
    var userInfo = PayflixUser(
      user.uid,
      user.email!,
      _avatar!,
      _profileName!,
      List.empty(),
    );

    return userInfo.toJson();
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
