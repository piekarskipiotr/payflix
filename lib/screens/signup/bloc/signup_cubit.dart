import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/signup/bloc/picking_avatar_dialog_bloc.dart';
import 'package:payflix/screens/signup/bloc/picking_avatar_dialog_state.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';

@injectable
class SignUpCubit extends Cubit<SignupState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepo;
  final PickingAvatarDialogBloc _pickingAvatarDialogBloc;
  late StreamSubscription _pickingAvatarDialogBlocSubscription;

  bool _tcppStatus = false;
  int? _avatarID;
  String? _profileName;
  String? _emailID;
  String? _password;

  SignUpCubit(this._authRepo, this._firestoreRepo, this._pickingAvatarDialogBloc) : super(InitSignupState()) {
    _pickingAvatarDialogBlocSubscription = _pickingAvatarDialogBloc.stream.listen((state) {
      if (state is AvatarPicked) {
        emit(ChangingAvatar());
        _avatarID = state.avatarID;
        var avatar = _pickingAvatarDialogBloc.getAvatars()[state.avatarID];
        var color = _pickingAvatarDialogBloc.getColors()[state.avatarID];
        emit(AvatarChanged(avatar, color));
      }
    });
  }

  PickingAvatarDialogBloc getDialogCubit() => _pickingAvatarDialogBloc;

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
          await _authRepo.instance().createUserWithEmailAndPassword(
                email: _emailID!,
                password: _password!,
              );

      var user = credential.user!;

      await user.updateDisplayName(_profileName);
      await _createUserData(user, _profileName!);
      await user.sendEmailVerification();

      emit(SigningUpSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(SigningUpFailed(e.code));
    } catch (e) {
      emit(SigningUpFailed(e as String?));
    }
  }

  Future<void> _createUserData(User user, String profileName) async {
    var userId = user.uid;
    var userData = _generateUserData(user, profileName);

    await _firestoreRepo.setUserData(docReference: userId, data: userData);
  }

  Map<String, dynamic> _generateUserData(User user, String profileName) {
    var userInfo = PayflixUser(
      user.uid,
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
