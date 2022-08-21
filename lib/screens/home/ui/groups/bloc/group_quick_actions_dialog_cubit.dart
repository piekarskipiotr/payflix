import 'dart:developer';

import 'package:flutter/services.dart';
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
  bool _showEmailIdCopiedText = false;
  bool _showPasswordCopiedText = false;
  bool _showBankAccountCopiedText = false;
  bool _showPhoneCopiedText = false;
  bool _isAccountAccessPasswordVisible = true;
  String _action = '';

  GroupQuickActionsDialogCubit(
    this._authRepo,
    this._firestoreRepository,
  ) : super(InitGroupQuickActionsDialogState());

  bool showSecondary() => _showSecondary;

  bool showCopiedText(String value) {
    switch (value) {
      case 'email-id':
        return _showEmailIdCopiedText;
      case 'password':
        return _showPasswordCopiedText;
      case 'bank-account':
        return _showBankAccountCopiedText;
      case 'phone-number':
        return _showPhoneCopiedText;
      default:
        return false;
    }
  }

  String getActionCodeName() => _action;

  bool isAccountAccessPasswordVisible() => _isAccountAccessPasswordVisible;

  Future copyData(Group group, String value) async {
    emit(ChangingCopiedTextVisibility());

    String? valueToCopy;
    switch (value) {
      case 'email-id':
        valueToCopy = group.accessData.emailID;
        break;
      case 'password':
        valueToCopy = group.accessData.password;
        break;
      case 'bank-account':
        valueToCopy = group.paymentInfo.bankAccountNumber;
        break;
      case 'phone-number':
        valueToCopy = group.paymentInfo.phoneNumber;
        break;
      default:
        valueToCopy = '';
        break;
    }

    Clipboard.setData(
      ClipboardData(
        text: valueToCopy,
      ),
    );

    // show 'copied' text below field
    _changeCopiedTextVisibility(value);
    emit(CopiedTextVisibilityChanged());

    // hide it after 3 seconds
    await Future.delayed(const Duration(seconds: 3));
    emit(ChangingCopiedTextVisibility());
    _changeCopiedTextVisibility(value);
    emit(CopiedTextVisibilityChanged());
  }

  void _changeCopiedTextVisibility(String value) {
    switch (value) {
      case 'email-id':
        _showEmailIdCopiedText = !_showEmailIdCopiedText;
        break;
      case 'password':
        _showPasswordCopiedText = !_showPasswordCopiedText;
        break;
      case 'bank-account':
        _showBankAccountCopiedText = !_showBankAccountCopiedText;
        break;
      case 'phone-number':
        _showPhoneCopiedText = !_showPhoneCopiedText;
        break;
    }
  }

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

  void changeAccountAccessPasswordVisibility() {
    emit(ChangingPasswordVisibility());
    _isAccountAccessPasswordVisible = !_isAccountAccessPasswordVisible;
    emit(PasswordVisibilityChanged());
  }

  void changeView({required String action}) {
    emit(ChangingDialogView());
    _action = action;
    _showSecondary = !_showSecondary;
    emit(DialogViewChanged());
  }

  void restartView() {
    emit(ChangingDialogView());
    _action = '-';
    _showSecondary = false;
    _isAccountAccessPasswordVisible = true;
    emit(DialogViewChanged());
  }

  @override
  void onChange(Change<GroupQuickActionsDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
