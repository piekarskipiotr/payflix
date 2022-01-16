import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/create_group/bloc/create_group_state.dart';

class CreateGroupBloc extends Cubit<CreateGroupState> {
  double? _payment;
  int? _dayOfPayment;
  String? _emailId;
  String? _password;

  CreateGroupBloc() : super(InitCreateGroupState());

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
    log('$_payment $_dayOfPayment $_emailId $_password');
    await Future.delayed(const Duration(seconds: 5));
    emit(CreatingGroupSucceeded());
  }

  @override
  void onChange(Change<CreateGroupState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
