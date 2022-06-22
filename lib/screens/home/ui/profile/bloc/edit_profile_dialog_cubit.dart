import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_state.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_cubit.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_state.dart';

@injectable
class EditProfileDialogCubit extends Cubit<EditProfileDialogState> {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final PickingAvatarDialogCubit _pickingAvatarDialogCubit;
  late StreamSubscription _pickingAvatarDialogCubitSubscription;

  PayflixUser? _payflixUser;
  String? _displayName;
  int? _avatarID;
  String? _avatar;
  Color? _color;

  EditProfileDialogCubit(this._authRepository, this._firestoreRepository,
      this._pickingAvatarDialogCubit)
      : super(InitEditProfileDialogState()) {
    _pickingAvatarDialogCubitSubscription =
        _pickingAvatarDialogCubit.stream.listen((state) {
      if (state is AvatarPicked) {
        emit(ChangingAvatar());
        _avatarID = state.avatarID;
        _avatar = _pickingAvatarDialogCubit.getAvatars()[state.avatarID];
        _color = _pickingAvatarDialogCubit.getColors()[state.avatarID];
        emit(AvatarChanged());
      }
    });
  }

  PickingAvatarDialogCubit getDialogCubit() => _pickingAvatarDialogCubit;

  void initVariables(String avatar, Color bg, PayflixUser user) {
    _avatar = avatar;
    _color = bg;
    _payflixUser = user;

    _pickingAvatarDialogCubit.pickAvatar(_payflixUser!.avatarID);
  }

  void setUserDisplayName(String value) => _displayName = value;

  String getAvatar() => _avatar!;

  Color getColor() => _color!;

  Future saveUserProfileChanges() async {
    emit(SavingUserProfileChanges());
    if (_payflixUser!.displayName == _displayName! &&
        _payflixUser!.avatarID == _avatarID!) {
      emit(UserDataSameAsPrevious());
    }

    var user = _authRepository.instance().currentUser;

    if (user != null) {
      var uid = user.uid;

      try {
        await user.updateDisplayName(_displayName);
        await _firestoreRepository.updateUserData(
          docReference: uid,
          data: {
            "avatar_id": _avatarID,
            "display_name": _displayName,
          },
        );

        _payflixUser!.displayName = _displayName!;
        _payflixUser!.avatarID = _avatarID!;
        emit(SavingUserProfileChangesSucceeded());
      } on FirebaseAuthException catch (e) {
        emit(SavingUserProfileChangesFailed(e.code));
      } catch (_) {
        emit(SavingUserProfileChangesFailed('other'));
      }
    } else {
      emit(SavingUserProfileChangesFailed('user-not-found'));
    }
  }

  @override
  Future<void> close() async {
    await _pickingAvatarDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<EditProfileDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
