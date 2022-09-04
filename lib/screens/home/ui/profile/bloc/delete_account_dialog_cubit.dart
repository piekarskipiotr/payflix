import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/home/ui/profile/bloc/delete_account_dialog_state.dart';

@injectable
class DeleteAccountDialogCubit extends Cubit<DeleteAccountDialogState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;

  DeleteAccountDialogCubit(
    this._firestoreRepository,
    this._authRepository,
  ) : super(InitDeleteAccountDialogState());

  Future deleteAccount(PayflixUser user) async {
    emit(DeletingAccount());
    try {
      var uid = user.id;
      var groups = user.groups;

      for (var groupId in groups) {
        var group = await _firestoreRepository.getGroupData(docReference: groupId);
        if (_isUserGroupAdmin(user, group)) {
          await _deleteGroup(group);
        } else {
          group.users?.removeWhere((element) => element == uid);
          await _firestoreRepository.updateGroupData(
            docReference: groupId,
            data: {
              "users": group.users,
            },
          );
        }
      }

      await _firestoreRepository.deleteUser(docReference: uid);
      await _authRepository.instance().currentUser?.delete();
      await _authRepository.instance().signOut();

      emit(DeletingAccountSucceeded());
    } catch (e) {
      emit(DeletingAccountFailed(e));
    }
  }

  bool _isUserGroupAdmin(PayflixUser user, Group group) {
    var uid = user.id;
    var groupId = group.getGroupId();
    var indexOfSuffix = groupId.indexOf('_');
    var pureGroupId = groupId.substring(0, indexOfSuffix);

    return uid == pureGroupId;
  }

  Future _deleteGroup(Group group) async {
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
    } catch (e) {
      emit(DeletingAccountFailed(e));
    }
  }

  @override
  void onChange(Change<DeleteAccountDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
