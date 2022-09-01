import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/members/bloc/remove_member_state.dart';

@injectable
class RemoveMemberCubit extends Cubit<RemoveMemberState> {
  final FirestoreRepository _firestoreRepository;

  RemoveMemberCubit(this._firestoreRepository) : super(InitRemoveMemberState());

  Future removeUser(
    PayflixUser user,
    Group group,
  ) async {
    emit(RemovingMember());

    try {
      var uid = user.id;
      var groupId = group.getGroupId();

      user.groups
          .removeWhere((element) => element == groupId);
      await _firestoreRepository.updateUserData(
        docReference: uid,
        data: {
          "groups": user.groups,
        },
      );

      group.users
          ?.removeWhere((element) => element == uid);
      await _firestoreRepository.updateGroupData(
        docReference: groupId,
        data: {
          "users": group.users,
        },
      );

      emit(RemovingMemberSucceeded(group));
    } catch (e) {
      emit(RemovingMemberFailed(e));
    }
  }

  @override
  void onChange(Change<RemoveMemberState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
