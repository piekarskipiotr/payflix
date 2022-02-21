import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/data/model/access_data.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';

class GroupSettingsCubit extends Cubit<GroupSettingsState> {
  double? _monthlyPayment;
  int? _dayOfTheMonth;
  String? _emailID;
  String? _password;

  GroupSettingsCubit() : super(InitGroupSettingsState());

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

  Future<void> saveSettings() async {
    emit(SavingSettings());
    try {
      var userID = getIt<FirebaseAuth>().currentUser?.uid.toString();
      if (userID == null) {
        throw 'user-id-not-found';
      }

      emit(CreatingGroupSucceeded());
    } catch (e) {
      emit(CreatingGroupFailed(e as String?));
    }
  }

  Future<void> createGroup() async {
    emit(CreatingGroup());
    try {
      var userID = getIt<FirebaseAuth>().currentUser?.uid.toString();
      if (userID == null) {
        throw 'user-id-not-found';
      }

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

      await getIt<FirebaseFirestore>()
          .collection('groups')
          .doc('${userID}_netflix')
          .set(group.toJson());

      emit(CreatingGroupSucceeded());
    } catch (e) {
      emit(CreatingGroupFailed(e as String?));
    }
  }

  @override
  void onChange(Change<GroupSettingsState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
