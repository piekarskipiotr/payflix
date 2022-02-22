import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/access_data.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';

class GroupSettingsCubit extends Cubit<GroupSettingsState> {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;

  double? _monthlyPayment;
  int? _dayOfTheMonth;
  String? _emailID;
  String? _password;

  GroupSettingsCubit(this._firebaseAuth, this._firebaseFirestore)
      : super(InitGroupSettingsState());

  void setMonthlyPayment(String? monthlyPayment) {
    if (monthlyPayment != null) {
      _monthlyPayment = double.tryParse(monthlyPayment);
    } else {
      _monthlyPayment = null;
    }
  }

  void setDayOfTheMonth(String? dayOfTheMonth) {
    if (dayOfTheMonth != null) {
      _dayOfTheMonth = int.tryParse(dayOfTheMonth);
    } else {
      _dayOfTheMonth = null;
    }
  }

  void setEmailID(String? emailID) => _emailID = emailID;

  void setPassword(String? password) => _password = password;

  Future<void> saveSettings(GroupType groupType) async {
    emit(SavingSettings());
    try {
      var userId = _firebaseAuth.currentUser?.uid.toString();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupId = _generateGroupId(userId, groupType);
      var groupData = _generateGroupData();
      await _firebaseFirestore
          .collection(groupsCollectionName)
          .doc(groupId)
          .update(groupData);

      emit(CreatingGroupSucceeded());
    } catch (e) {
      emit(CreatingGroupFailed(e as String?));
    }
  }

  Future<void> createGroup(GroupType groupType) async {
    emit(CreatingGroup());
    try {
      var userId = _firebaseAuth.currentUser?.uid.toString();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupId = _generateGroupId(userId, groupType);
      var groupData = _generateGroupData();
      await _firebaseFirestore
          .collection(groupsCollectionName)
          .doc(groupId)
          .set(groupData);

      emit(CreatingGroupSucceeded());
    } catch (e) {
      emit(CreatingGroupFailed(e as String?));
    }
  }

  String _generateGroupId(String userId, GroupType groupType) =>
      '${userId}_${groupType.codeName}';

  Map<String, dynamic> _generateGroupData() {
    var paymentInfo = PaymentInfo(
      monthlyPayment: _monthlyPayment!,
      dayOfTheMonth: _dayOfTheMonth!,
    );

    var accessData = AccessData(
      emailID: _emailID,
      password: _password,
    );

    var group = Group(
      paymentInfo: paymentInfo,
      accessData: accessData,
    );

    return group.toJson();
  }

  @override
  void onChange(Change<GroupSettingsState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
