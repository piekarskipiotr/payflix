import 'dart:developer';

import 'package:flutter/material.dart';
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
  List<PayflixUser> _members = List.empty(growable: true);
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
      _members = await _firestoreRepository.getMembers(ids: ids, uid: uid);

      emit(FetchingMembersSucceeded(_members));
    } catch (e) {
      emit(FetchingMembersFailed());
    }
  }

  Future refreshData({required HomeCubit cubit, required BuildContext context}) async {
    if (_group != null) {
      try {
        var group = await _firestoreRepository.getGroupData(
            docReference: _group!.getGroupId());
        cubit.updateGroupData(group, context);

        var ids = group.users!;
        var uid = _authRepo.getUID()!;
        _members = await _firestoreRepository.getMembers(ids: ids, uid: uid);

        emit(FetchingMembersSucceeded(_members));
      } catch (e) {
        emit(FetchingMembersFailed());
      }
    }
  }

  void updateGroup(Group group, BuildContext context) {
    emit(RefreshingData());

    _homeCubit?.updateGroupData(group, context);
    _group = group;

    emit(FetchingMembersSucceeded(_members));
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
