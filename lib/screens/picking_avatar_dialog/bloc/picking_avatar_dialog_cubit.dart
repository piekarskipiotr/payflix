import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/avatar.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_state.dart';

@injectable
class PickingAvatarDialogCubit extends Cubit<PickingAvatarDialogState> {
  final FirestoreRepository _firestoreRepository;
  List<Avatar> _avatars = List.empty(growable: true);
  PickingAvatarDialogCubit(this._firestoreRepository) : super(InitPickingAvatarDialogState()) {
    _initialize();
  }

  List<Avatar> getAvatars() => _avatars;

  Future _initialize() async {
    emit(FetchingAvatars());
    _avatars = await _firestoreRepository.getAvatars();
    emit(AvatarsFetched());
  }

  void pickAvatar(Avatar avatar) {
    emit(PickingAvatar());
    emit(AvatarPicked(avatar));
  }

  @override
  void onChange(Change<PickingAvatarDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
