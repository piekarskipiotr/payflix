import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';

class LoginBloc extends Cubit<LoginState> {
  String? _emailId;
  String? _password;

  LoginBloc() : super(InitLoginState());

  Future<void> restartPassword() async {
    // TODO: show bottom sheet view dialog with confirmation of sending email & setting new one
    log('should show bottom sheet view dialog with restarting password procedure');
  }

  void setEmailId(String? value) {
    _emailId = value;
  }

  void setPassword(String? value) {
    _password = value;
  }

  Future<void> authenticateUserByForm() async {
    // TODO: try to login user by form
    log('should start form logging procedure with data: {\nEmailID: $_emailId,\nPassword: $_password\n}');
  }

  Future<void> authenticateUserByGoogleAccount() async {
    // TODO: try to login user by google account
    log('should start google logging procedure');
  }

  Future<void> authenticateUserByAppleAccount() async {
    // TODO: try to login user by apple account
    log('should start apple logging procedure');
  }

  @override
  void onChange(Change<LoginState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}