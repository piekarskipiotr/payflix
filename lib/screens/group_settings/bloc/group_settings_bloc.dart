import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_settings_state.dart';

class GroupSettingsBloc extends Cubit<GroupSettingsState> {
  double? _payment;
  int? _dayOfPayment;
  String? _emailId;
  String? _password;

  GroupSettingsBloc() : super(InitGroupSettingsState());

  void setPayment(String payment) {
    _payment = double.tryParse(payment);
  }

  void setDayOfPayment(String dayOfPayment) {
    _dayOfPayment = int.tryParse(dayOfPayment);
  }

  void setEmailId(String? emailId) {
    _emailId = emailId;
  }

  void setPassword(String? password) {
    _password = password;
  }

  Future<void> createGroup() async {
    emit(CreatingGroup());
    try {
     var group = await FirebaseFirestore.instance.collection('groups').add({
        'payment_information': {
          'payment': '$_payment',
          'day_of_payment': '$_dayOfPayment'
        },
        'access_data': {'email_id': '$_emailId', 'password': '$_password'}
      });

      var user = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'groups_maintainer': FieldValue.arrayUnion([group.id])
      });

      emit(CreatingGroupSucceeded());
    } catch (e) {
      log(e.toString());
      emit(CreatingGroupFailed());
    }
  }

  @override
  void onChange(Change<GroupSettingsState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
