import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';

@injectable
class PickingVodDialogCubit extends Cubit<PickingVodDialogState> {
  GroupType? _groupType;
  List<Group> _groups = List.empty();

  PickingVodDialogCubit() : super(InitPickingVodDialogState());

  void setUserGroup(List<Group> groups) => _groups = groups;

  bool doesUserHasVodGroupAlready(GroupType groupType) {
    for (var group in _groups) {
      if (group.groupType == groupType) {
        return true;
      }
    }

    return false;
  }

  List<GroupType> getVods() => GroupType.values;

  GroupType? getPickedVod() => _groupType;

  void pickVod(GroupType groupType) {
    emit(PickingVod());
    _groupType = groupType;
    emit(VodPicked(groupType));
  }

  void clearPick() => _groupType = null;

  @override
  void onChange(Change<PickingVodDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
