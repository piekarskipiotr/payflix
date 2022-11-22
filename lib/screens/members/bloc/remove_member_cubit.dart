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
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/data/repository/notification_repository.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/members/bloc/remove_member_state.dart';

@injectable
class RemoveMemberCubit extends Cubit<RemoveMemberState> {
  final FirestoreRepository _firestoreRepository;
  final NotificationRepository _notificationRepository;

  RemoveMemberCubit(
    this._firestoreRepository,
    this._notificationRepository,
  ) : super(InitRemoveMemberState());

  Future removeUser(
    PayflixUser user,
    Group group,
    BuildContext context,
  ) async {
    emit(RemovingMember());

    try {
      var uid = user.id;
      var groupId = group.getGroupId();

      user.groups.removeWhere((element) => element == groupId);
      await _firestoreRepository.updateUserData(
        docReference: uid,
        data: {
          "groups": user.groups,
        },
      );

      group.users?.removeWhere((element) => element == uid);
      await _firestoreRepository.updateGroupData(
        docReference: groupId,
        data: {
          "users": group.users,
        },
      );

      final adminUID = group.getAdminUID();
      for (var userId in group.users ?? []) {
        var user = await _firestoreRepository.getUserData(docReference: userId);
        await _updatePayments(user, groupId, group.getPaymentPerUser());

        if (userId != adminUID) {
          final isRemovingUser = userId == uid;
          final title = isRemovingUser
              ? getString(context).removed_from_group_notification_title
              : getString(context).payment_price_changed_notification_title;

          final body = isRemovingUser
              ? getString(context).removed_from_group_notification_body
              : getString(context).payment_price_changed_notification_body(
                  group.groupType.vodName,
                  group.getPaymentPerUser(),
                  group.paymentInfo.currency,
                );

          _notificationRepository.sendPushMessage(
            title,
            body,
            user.devicesToken,
            'def-action',
          );
        }
      }

      emit(RemovingMemberSucceeded(group));
    } catch (e) {
      emit(RemovingMemberFailed(e));
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

  @override
  void onChange(Change<RemoveMemberState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
