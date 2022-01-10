import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/email_verify_waiting_room/bloc/email_verify_waiting_room_state.dart';

class EmailVerifyWaitingRoomBloc extends Cubit<EmailVerifyWaitingRoomState> {
  EmailVerifyWaitingRoomBloc() : super(InitEmailVerifyWaitingRoomState());

  Future<bool> popAndLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(context);
    return true;
  }

  Future<void> resendVerificationEmail() async {
    emit(SendingVerificationEmail());
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      emit(SendingVerificationEmailSucceeded());
    } on FirebaseAuthException catch (_) {
      emit(SendingVerificationEmailFailed());
    } catch (_) {
      emit(SendingVerificationEmailFailed());
    }
  }

  @override
  void onChange(Change<EmailVerifyWaitingRoomState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
