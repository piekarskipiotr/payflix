import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/members/bloc/members_state.dart';

@injectable
class MembersCubit extends Cubit<MembersState> {
  Group? _group;
  HomeCubit? _homeCubit;
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  MembersCubit(this._authRepo, this._firestoreRepository)
      : super(InitMembersState());

  bool isCurrentUser(PayflixUser user) => _authRepo.getUID() == user.id;

  Future _fetchMembers(Group group) async {
    try {
      emit(FetchingMembers());

      var ids = group.users!;
      var uid = _authRepo.getUID()!;
      var members = await _firestoreRepository.getMembers(ids: ids, uid: uid);

      emit(FetchingMembersSucceeded(members));
    } catch (e) {
      emit(FetchingMembersFailed());
    }
  }

  Future refreshData({required HomeCubit cubit}) async {
    if (_group != null) {
      try {
        var group = await _firestoreRepository.getGroupData(
            docReference: _group!.getGroupId());
        cubit.updateGroupData(group);

        var ids = group.users!;
        var uid = _authRepo.getUID()!;
        var members = await _firestoreRepository.getMembers(ids: ids, uid: uid);

        emit(FetchingMembersSucceeded(members));
      } catch (e) {
        emit(FetchingMembersFailed());
      }
    }
  }

  void updateGroup(Group group) {
    _homeCubit?.updateGroupData(group);
    _group = group;
  }

  Future initialize(Group group, HomeCubit homeCubit) async {
    if (_group == null && _homeCubit == null) {
      emit(InitializingMembers());
      _group = group;
      _homeCubit = homeCubit;
      await _fetchMembers(_group!);
    }
  }

  Group? getGroup() => _group;

  @override
  void onChange(Change<MembersState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
