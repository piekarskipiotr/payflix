import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/members/bloc/members_state.dart';

@injectable
class MembersCubit extends Cubit<MembersState> {
  Group? _group;
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  MembersCubit(this._authRepo, this._firestoreRepository)
      : super(InitMembersState());

  Future _fetchMembers(Group group) async {
    emit(FetchingMembers());

    var ids = group.users!;
    var uid = _authRepo.getUID()!;
    var members = await _firestoreRepository.getMembers(ids: ids, uid: uid);

    emit(FetchingMembersSucceeded(members));
  }

  Future initialize(Group? group) async {
    emit(InitializingGroup());
    if (group == null) {
      var uid = _authRepo.getUID();
      var user = await _firestoreRepository.getUserData(docReference: uid!);
      if (user.groups.isNotEmpty) {
        group = await _firestoreRepository.getGroupData(
            docReference: user.groups.first);
        await initialize(group);
      }
    } else {
      log('group: ${group.toString()}');
      _group = group;
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
