import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void onChange(Change<JoinGroupRoomState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}