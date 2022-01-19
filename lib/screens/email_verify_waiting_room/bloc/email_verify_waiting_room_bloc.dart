import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/email_verify_waiting_room/bloc/email_verify_waiting_room_state.dart';

class EmailVerifyWaitingRoomBloc extends Cubit<EmailVerifyWaitingRoomState> {
  Timer? _timer;

  EmailVerifyWaitingRoomBloc() : super(InitEmailVerifyWaitingRoomState());

  Future<bool> popAndLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    clearSnackBars(context);
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
    return true;
  }

  void clearSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  Future<void> emailVerificationListener() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser!.reload();
      var user = FirebaseAuth.instance.currentUser;
      if (user!.emailVerified) {
        timer.cancel();
        emit(EmailVerifiedMovingToJoinGroupRoom());
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  void onChange(Change<EmailVerifyWaitingRoomState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
