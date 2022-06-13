import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;
  final PickingVodDialogCubit _pickingVodDialogCubit;
  late StreamSubscription _pickingVodDialogCubitSubscription;
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

  final _groups = List<Group>.empty(growable: true);
  PayflixUser? _payflixUser;

  HomeCubit(
      this._authRepo, this._firestoreRepository, this._pickingVodDialogCubit)
      : super(InitHomeState()) {
    fetchData();
    _pickingVodDialogCubitSubscription = _pickingVodDialogCubit.stream.listen(
      (state) {
        if (state is VodPicked) {
          emit(VodSelected());

          var vod = state.groupType;
          getVodDialogCubit().clearPick();
          emit(NavigateToGroupCreator(vod));
        }
      },
    );
  }

  List<Group> getGroups() => _groups;

  bool isUserGroupAdmin(Group group) {
    var uid = _authRepo.getUID();
    var groupId = group.getGroupId();
    var indexOfSuffix = groupId.indexOf('_');
    var pureGroupId = groupId.substring(0, indexOfSuffix);

    return uid == pureGroupId;
  }

  PayflixUser? getPayflixUser() => _payflixUser;

  String getAvatar(int index) => _avatars[index];

  Color getColor(int index) => _colors[index];

  PickingVodDialogCubit getVodDialogCubit() => _pickingVodDialogCubit;

  Future logOut() async {
    emit(LoggingOut());
    await _authRepo.instance().signOut();
    emit(LoggingOutCompleted());
  }

  Future fetchData() async {
    emit(FetchingData());
    _groups.clear();
    var user = _authRepo.instance().currentUser;

    if (user != null) {
      var uid = user.uid;
      _payflixUser = await _firestoreRepository.getUserData(docReference: uid);
      var userGroups = _payflixUser!.groups;

      for (var id in userGroups) {
        var groupData =
            await _firestoreRepository.getGroupData(docReference: id);
        _groups.add(groupData);
      }

      getVodDialogCubit().setUserGroup(_groups);
      emit(FetchingDataSucceeded());
    } else {
      emit(FetchingDataFailed());
    }
  }

  @override
  Future<void> close() async {
    await _pickingVodDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<HomeState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
