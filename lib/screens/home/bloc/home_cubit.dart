import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;
  final PickingVodDialogCubit _pickingVodDialogCubit;
  late StreamSubscription _pickingVodDialogCubitSubscription;

  final _groups = List<Group>.empty(growable: true);

  HomeCubit(
      this._authRepo, this._firestoreRepository, this._pickingVodDialogCubit)
      : super(InitHomeState()) {
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

  List<Group> getFetchedGroups() => _groups;

  PickingVodDialogCubit getVodDialogCubit() => _pickingVodDialogCubit;

  Future fetchPageData(int pageIndex) async {
    switch (pageIndex) {
      case 0:
        await getGroups();
        break;
      case 1:
        await getUserProfile();
        break;
    }
  }

  Future getGroups() async {
    emit(FetchingGroups());
    _groups.clear();
    var user = _authRepo.instance().currentUser;

    if (user != null) {
      var uid = user.uid;
      var userData = await _firestoreRepository.getUserData(docReference: uid);
      var userGroups = userData.groups;

      for (var id in userGroups) {
        var groupData =
            await _firestoreRepository.getGroupData(docReference: id);
        _groups.add(groupData);
      }

      getVodDialogCubit().setUserGroup(_groups);
      emit(FetchingGroupsSucceeded());
    } else {
      emit(FetchingGroupsFailed());
    }
  }

  Future getUserProfile() async {}

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
