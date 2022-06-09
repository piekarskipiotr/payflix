import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  HomeCubit(this._authRepo, this._firestoreRepository) : super(InitHomeState());

  Future fetchPageData(int pageIndex) async {
    switch(pageIndex) {
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
    var user = _authRepo.instance().currentUser;

    if (user != null) {
      var uid = user.uid;
      var userData = await _firestoreRepository.getUserData(docReference: uid);
      var userGroups = userData.groups;

      var groups = List<Group>.empty(growable: true);
      for (var id in userGroups) {
        var groupData = await _firestoreRepository.getGroupData(docReference: id);
        groups.add(groupData);
      }

      emit(FetchingGroupsSucceeded(groups));
    } else {
      emit(FetchingGroupsFailed());
    }
  }

  Future getUserProfile() async {

  }

  @override
  void onChange(Change<HomeState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}