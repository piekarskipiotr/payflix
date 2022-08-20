import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_state.dart';

@injectable
class GroupQuickActionsDialogCubit extends Cubit<GroupQuickActionsDialogState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  bool _showSecondary = false;
  String _action = '';

  GroupQuickActionsDialogCubit(
    this._authRepo,
    this._firestoreRepository,
  ) : super(InitGroupQuickActionsDialogState());

  bool showSecondary() => _showSecondary;

  String getActionCodeName() => _action;

  Future leaveGroup(Group group) async {
    emit(LeavingGroup());
    var groupId = group.getGroupId();
    var uid = _authRepo.getUID();

    try {
      group = await _firestoreRepository.getGroupData(docReference: groupId);
      group.users!.removeWhere((element) => element == uid);
      await _firestoreRepository.updateGroupData(docReference: groupId, data: {
        "users": group.users,
      });

      PayflixUser userData = await _firestoreRepository.getUserData(
        docReference: uid!,
      );

      userData.groups.removeWhere((element) => element == groupId);
      await _firestoreRepository.updateUserData(
        docReference: uid,
        data: {
          "groups": userData.groups,
        },
      );

      emit(LeavingGroupSucceeded());
    } catch (_) {
      emit(LeavingGroupFailed());
    }

    _showSecondary = false;
  }

  void changeView({required String action}) {
    emit(ChangingDialogView());
    _action = action;
    _showSecondary = !_showSecondary;
    emit(DialogViewChanged());
  }

  @override
  void onChange(Change<GroupQuickActionsDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
