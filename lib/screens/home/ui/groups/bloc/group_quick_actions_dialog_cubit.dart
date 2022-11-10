import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/enum/payment_month_action.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/month_payment_history.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/data/repository/notification_repository.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_state.dart';

@injectable
class GroupQuickActionsDialogCubit extends Cubit<GroupQuickActionsDialogState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;
  final NotificationRepository _notificationRepository;

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
    this._notificationRepository,
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

  Future leaveGroup(Group group, BuildContext context) async {
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

      for (var userId in group.users ?? []) {
        var user = await _firestoreRepository.getUserData(docReference: userId);
        await _updatePayments(user, groupId, group.getPaymentPerUser());

        if (userId != uid) {
          final isAdmin = userId == group.getAdminUID();
          final title = isAdmin
              ? getString(context).user_left_notification_title
              : getString(context).payment_price_changed_notification_title;

          final body = isAdmin
              ? getString(context).user_left_notification_body
              : getString(context).payment_price_changed_notification_body(
                  group.groupType.vodName,
                  group.getPaymentPerUser(),
                );

          _notificationRepository.sendPushMessage(
            title,
            body,
            user.devicesToken,
            'def-action',
          );
        }
      }

      emit(LeavingGroupSucceeded());
    } catch (_) {
      emit(LeavingGroupFailed());
    }

    _showSecondary = false;
  }

  Future _updatePayments(PayflixUser user, String groupId, double price) async {
    var mpiList = user.payments[groupId] ?? [];
    var now = clock.now();
    var today = DateTime(now.year, now.month, now.day);

    for (var mpi in mpiList) {
      if (mpi.date.isAfter(today) || mpi.date.isAtSameMomentAs(today)) {
        mpi.payment = price;
        if (mpi.status == PaymentMonthStatus.paid) {
          mpi.status = PaymentMonthStatus.priceModified;
          mpi.history.add(
            MonthPaymentHistory(
              DateTime(
                now.year,
                now.month,
                now.day,
                now.hour,
                now.minute,
                now.second,
              ),
              PaymentMonthAction.priceModified,
            ),
          );
        }
      }
    }

    user.payments[groupId] = mpiList;
    await _firestoreRepository.updateUserData(
      docReference: user.id,
      data: {
        "payments.$groupId": FieldValue.arrayUnion(
          mpiList.map((e) => e.toJson()).toList(),
        ),
      },
    );
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
