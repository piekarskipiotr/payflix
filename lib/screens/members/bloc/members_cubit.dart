import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';
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

  bool isCurrentUser(PayflixUser user) => _authRepo.getUID() == user.id;

  Future _fetchMembers(Group group) async {
    emit(FetchingMembers());

    var ids = group.users!;
    var uid = _authRepo.getUID()!;
    var members = await _firestoreRepository.getMembers(ids: ids, uid: uid);

    emit(FetchingMembersSucceeded(members));
  }

  Future initialize(Group group) async {
    if (_group == null) {
      emit(InitializingGroup());
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
