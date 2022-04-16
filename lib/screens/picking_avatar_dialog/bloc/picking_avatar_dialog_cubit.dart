import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_state.dart';

@injectable
class PickingAvatarDialogCubit extends Cubit<PickingAvatarDialogState> {
  int? _avatarID;

  final _avatars = [
    avatar1,
    avatar2,
    avatar3,
    avatar4,
    avatar5,
  ];

  final _colors = [
    AppColors.primary,
    Colors.greenAccent,
    Colors.blue,
    Colors.orange,
    Colors.pink,
  ];

  PickingAvatarDialogCubit() : super(InitPickingAvatarDialogState());

  List<String> getAvatars() => _avatars;

  List<Color> getColors() => _colors;

  int? getAvatarId() => _avatarID;

  void pickAvatar(int id) {
    emit(PickingAvatar());
    _avatarID = id;
    emit(AvatarPicked(id));
  }

  @override
  void onChange(Change<PickingAvatarDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
