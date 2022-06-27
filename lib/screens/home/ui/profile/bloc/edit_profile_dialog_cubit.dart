import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/avatar.dart';
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
  Avatar? _avatar;

  EditProfileDialogCubit(this._authRepository, this._firestoreRepository,
      this._pickingAvatarDialogCubit)
      : super(InitEditProfileDialogState()) {
    _pickingAvatarDialogCubitSubscription =
        _pickingAvatarDialogCubit.stream.listen((state) {
      if (state is AvatarPicked) {
        emit(ChangingAvatar());
        _avatar = state.avatar;
        emit(AvatarChanged());
      }
    });
  }

  void initUser(PayflixUser user) {
    _payflixUser = user;
  }

  Avatar getAvatar() => _avatar ?? _payflixUser!.avatar;

  PickingAvatarDialogCubit getDialogCubit() => _pickingAvatarDialogCubit;

  void setUserDisplayName(String value) => _displayName = value;

  Future saveUserProfileChanges() async {
    emit(SavingUserProfileChanges());
    if (_payflixUser!.displayName == _displayName! &&
        _payflixUser!.avatar == _avatar) {
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
            "avatar": _avatar!.toJson(),
            "display_name": _displayName,
          },
        );

        _payflixUser!.displayName = _displayName!;
        _payflixUser!.avatar = _avatar!;
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
