import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/access_data.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/data/repository/firebase_repository.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';

@injectable
class GroupSettingsCubit extends Cubit<GroupSettingsState> {
  final FirebaseRepository _firebaseRepo;

  double? _monthlyPayment;
  int? _dayOfTheMonth;
  String? _emailID;
  String? _password;

  GroupSettingsCubit(this._firebaseRepo) : super(InitGroupSettingsState());

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
      var userId = _firebaseRepo.auth().currentUser?.uid.toString();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupId = _generateGroupId(userId, groupType);
      var groupData = _generateGroupData();
      await _firebaseRepo
          .firestore()
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
      var userId = _firebaseRepo.auth().currentUser?.uid.toString();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupId = _generateGroupId(userId, groupType);
      var groupData = _generateGroupData();
      await _firebaseRepo
          .firestore()
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
