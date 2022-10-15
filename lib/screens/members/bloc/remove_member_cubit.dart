import 'dart:developer';

import 'package:clock/clock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
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

      for (var user in group.users ?? []) {
        await _updatePayments(user, groupId, group.getPaymentPerUser());
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
  void onChange(Change<RemoveMemberState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
