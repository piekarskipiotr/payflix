import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/join_group_room/bloc/join_group_room_state.dart';

class JoinGroupRoomBloc extends Cubit<JoinGroupRoomState> {
  String? _code;
  JoinGroupRoomBloc() : super(InitJoinGroupRoomState());

  Future joinGroup(String? code) async {
    emit(JoiningTheGroup());
    if (code != null) {
      _code = code;
    }
  }


  Future<bool> popAndLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.login, (route) => false);
    return true;
  }

  @override
  void onChange(Change<JoinGroupRoomState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}