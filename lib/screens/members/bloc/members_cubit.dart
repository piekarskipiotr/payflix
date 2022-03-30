import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/screens/members/bloc/members_state.dart';

@injectable
class MembersCubit extends Cubit<MembersState> {
  Group? _group;
  MembersCubit() : super(InitMembersState());

  Future _fetchMembers(Group group) async {

  }

  Future initialize(Group group) async {
    _group = group;
    await _fetchMembers(_group!);
  }
}