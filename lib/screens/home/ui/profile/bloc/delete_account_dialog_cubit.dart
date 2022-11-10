import 'dart:async';
import 'dart:developer';
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
import 'package:payflix/screens/home/ui/profile/bloc/delete_account_dialog_state.dart';

@injectable
class DeleteAccountDialogCubit extends Cubit<DeleteAccountDialogState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  final NotificationRepository _notificationRepository;

  DeleteAccountDialogCubit(
    this._firestoreRepository,
    this._authRepository,
    this._notificationRepository,
  ) : super(InitDeleteAccountDialogState());

  Future deleteAccount(PayflixUser user, BuildContext context) async {
    emit(DeletingAccount());
    try {
      var uid = user.id;
      var groups = user.groups;

      for (var groupId in groups) {
        var group =
            await _firestoreRepository.getGroupData(docReference: groupId);
        if (_isUserGroupAdmin(user, group)) {
          await _deleteGroup(group);
        } else {
          group.users?.removeWhere((element) => element == uid);
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
