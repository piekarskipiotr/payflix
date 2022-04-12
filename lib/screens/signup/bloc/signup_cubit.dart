import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/signup/bloc/picking_avatar_dialog_cubit.dart';
import 'package:payflix/screens/signup/bloc/picking_avatar_dialog_state.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';

@injectable
class SignUpCubit extends Cubit<SignupState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepo;
  final PickingAvatarDialogCubit _pickingAvatarDialogBloc;
  late StreamSubscription _pickingAvatarDialogBlocSubscription;

  bool _tcppStatus = false;
  int? _avatarID;
  String? _profileName;
  String? _emailID;
  String? _password;
  String? avatar;
  Color? color;

  SignUpCubit(
      this._authRepo, this._firestoreRepo, this._pickingAvatarDialogBloc)
      : super(InitSignupState()) {
    _pickingAvatarDialogBlocSubscription =
        _pickingAvatarDialogBloc.stream.listen((state) {
      if (state is AvatarPicked) {
        emit(ChangingAvatar());
        _avatarID = state.avatarID;
        avatar = _pickingAvatarDialogBloc.getAvatars()[state.avatarID];
        color = _pickingAvatarDialogBloc.getColors()[state.avatarID];
        emit(AvatarChanged());
      }
    });
  }

  PickingAvatarDialogCubit getDialogCubit() => _pickingAvatarDialogBloc;

  bool isTCPPAccepted() => _tcppStatus;

  bool isAllFilledUp() => _tcppStatus && (_avatarID != null);

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
      var uid = user.uid;

      await _createUserData(uid, _avatarID!, _profileName!);
      await user.updateDisplayName(_profileName);
      await user.sendEmailVerification();

      emit(SigningUpSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SigningUpFailed(e.code));
    } catch (e) {
      emit(SigningUpFailed(e as String?));
    }
  }

  Future<void> _createUserData(
      String uid, int avatarID, String profileName) async {
    var userData = _generateUserData(uid, avatarID, profileName);
    await _firestoreRepo.setUserData(docReference: uid, data: userData);
  }

  Map<String, dynamic> _generateUserData(
      String uid, int avatarID, String profileName) {
    var userInfo = PayflixUser(
      uid,
      avatarID,
      profileName,
      List.empty(),
    );

    return userInfo.toJson();
  }

  @override
  Future<void> close() async {
    await _pickingAvatarDialogBlocSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<SignupState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
