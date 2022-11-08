import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/data/repository/notification_repository.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_cubit.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_state.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_cubit.dart';
import 'package:payflix/screens/home/ui/profile/bloc/edit_profile_dialog_state.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;
  final NotificationRepository _notificationRepository;

  final PickingVodDialogCubit _pickingVodDialogCubit;
  late StreamSubscription _pickingVodDialogCubitSubscription;

  final EditProfileDialogCubit _editProfileDialogCubit;
  late StreamSubscription _editProfileDialogCubitSubscription;

  final GroupQuickActionsDialogCubit _groupQuickActionsDialogCubit;
  late StreamSubscription _groupQuickActionsDialogCubitSubscription;

  final _groups = List<Group>.empty(growable: true);
  PayflixUser? _payflixUser;

  HomeCubit(
    this._authRepo,
    this._firestoreRepository,
    this._notificationRepository,
    this._pickingVodDialogCubit,
    this._editProfileDialogCubit,
    this._groupQuickActionsDialogCubit,
  ) : super(InitHomeState()) {
    fetchData(isRefresh: false);

    _editProfileDialogCubitSubscription =
        _editProfileDialogCubit.stream.listen((state) {
      if (state is SavingUserProfileChangesSucceeded) {
        emit(RefreshingView());
        emit(ViewRefreshed());
      }
    });

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

    _groupQuickActionsDialogCubitSubscription =
        _groupQuickActionsDialogCubit.stream.listen(
      (state) {
        if (state is LeavingGroupSucceeded) {
          fetchData(isRefresh: false);
        }
      },
    );
  }

  Future initNotifications(BuildContext context) async {
    _notificationRepository.requestPermission(context);
    _notificationRepository.loadFCM();
    _notificationRepository.listenFCM();
  }

  List<Group> getGroups() => _groups;

  void updateGroupData(Group group) {
    emit(RefreshingData());
    var index = _groups.indexWhere((g) => g.getGroupId() == group.getGroupId());
    _groups[index] = group;

    getVodDialogCubit().setUserGroup(_groups);
    emit(FetchingDataSucceeded());
  }

  bool isUserGroupAdmin(Group group, String? customUserId) {
    var uid = customUserId ?? _authRepo.getUID();
    var groupId = group.getGroupId();
    var indexOfSuffix = groupId.indexOf('_');
    var pureGroupId = groupId.substring(0, indexOfSuffix);

    return uid == pureGroupId;
  }

  PayflixUser? getPayflixUser() => _payflixUser;

  PickingVodDialogCubit getVodDialogCubit() => _pickingVodDialogCubit;

  EditProfileDialogCubit getProfileEditCubit() => _editProfileDialogCubit;

  GroupQuickActionsDialogCubit getGQADialogCubit() =>
      _groupQuickActionsDialogCubit;

  Future logOut() async {
    emit(LoggingOut());
    await _authRepo.instance().signOut();
    emit(LoggingOutCompleted());
  }

  Future fetchData({required bool isRefresh}) async {
    emit(isRefresh ? RefreshingData() : FetchingData());
    var user = _authRepo.instance().currentUser;

    if (user != null) {
      var uid = user.uid;
      _payflixUser = await _firestoreRepository.getUserData(docReference: uid);
      var userGroups = _payflixUser!.groups;

      _groups.clear();
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
    await _editProfileDialogCubitSubscription.cancel();
    await _groupQuickActionsDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<HomeState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
