import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';

@injectable
class JoiningGroupDialogCubit extends Cubit<JoiningGroupDialogState> {
  final FirestoreRepository _firestoreRepository;

  JoiningGroupDialogCubit(this._firestoreRepository)
      : super(InitJoiningGroupDialogState());

  Future cancelJoining() async => emit(JoiningToGroupCanceled());

  Future addUserToGroup(String uid, String groupId) async {
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
    for (var user in group.users ?? []) {
      await _updatePayments(user, groupId, group.getPaymentPerUser());
    }

    emit(JoiningToGroupSucceeded());
  }

  Future _updatePayments(PayflixUser user, String groupId, double price) async {
    var mpiList = user.payments[groupId] ?? [];
    var now = clock.now();
    var today = DateTime(now.year, now.month, now.day);

    for (var mpi in mpiList) {
      if (mpi.date.isAfter(today)) {
        mpi.payment = price;
        if (mpi.status == PaymentMonthStatus.paid) {
          mpi.status = PaymentMonthStatus.priceModified;
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
  void onChange(Change<JoiningGroupDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
