import 'dart:developer';
import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/enum/payment_month_action.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/month_payment_history.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/data/repository/notification_repository.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';

@injectable
class JoiningGroupDialogCubit extends Cubit<JoiningGroupDialogState> {
  final FirestoreRepository _firestoreRepository;
  final NotificationRepository _notificationRepository;

  JoiningGroupDialogCubit(
    this._firestoreRepository,
    this._notificationRepository,
  ) : super(InitJoiningGroupDialogState());

  Future cancelJoining() async => emit(JoiningToGroupCanceled());

  Future addUserToGroup(
    String uid,
    String groupId,
    BuildContext context,
  ) async {
    emit(JoiningToGroup());

    await _firestoreRepository.updateUserData(
      docReference: uid,
      data: {
        "groups": FieldValue.arrayUnion([groupId])
      },
    );

    await _firestoreRepository.updateGroupData(
      docReference: groupId,
      data: {
        "users": FieldValue.arrayUnion([uid])
      },
    );

    var group = await _firestoreRepository.getGroupData(docReference: groupId);
    for (var userId in group.users ?? []) {
      var user = await _firestoreRepository.getUserData(docReference: userId);
      await _updatePayments(user, groupId, group.getPaymentPerUser());

      if (userId != uid) {
        final isAdmin = userId == group.getAdminUID();
        final title = isAdmin
            ? getString(context).new_user_notification_title
            : getString(context).payment_price_changed_notification_title;

        final body = isAdmin
            ? getString(context).new_user_notification_body
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

    emit(JoiningToGroupSucceeded());
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
        "payments.$groupId": mpiList.map((e) => e.toJson()).toList(),
      },
    );
  }

  @override
  void onChange(Change<JoiningGroupDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
