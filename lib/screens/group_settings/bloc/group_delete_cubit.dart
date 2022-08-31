import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/group_settings/bloc/group_delete_state.dart';

@injectable
class GroupDeleteCubit extends Cubit<GroupDeleteState> {
  final FirestoreRepository _firestoreRepository;

  GroupDeleteCubit(this._firestoreRepository) : super(InitGroupDeleteState());

  Future deleteGroup(Group group) async {
    emit(DeletingGroup());
    try {
      var groupId = group.getGroupId();
      await _firestoreRepository.deleteGroup(docReference: groupId);

      var usersId = group.users ?? [];
      for (var uid in usersId) {
        PayflixUser userData = await _firestoreRepository.getUserData(
          docReference: uid,
        );

        userData.groups.removeWhere((element) => element == groupId);
        await _firestoreRepository.updateUserData(
          docReference: uid,
          data: {
            "groups": userData.groups,
          },
        );
      }

      emit(DeletingGroupSucceeded());
    } catch (e) {
      emit(DeletingGroupFailed(e));
    }
  }

  @override
  void onChange(Change<GroupDeleteState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
