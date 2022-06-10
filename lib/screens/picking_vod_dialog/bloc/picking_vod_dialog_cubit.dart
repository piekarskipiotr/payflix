import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';

@injectable
class PickingVodDialogCubit extends Cubit<PickingVodDialogState> {
  GroupType? _groupType;

  PickingVodDialogCubit() : super(InitPickingVodDialogState());

  List<GroupType> getVods() => GroupType.values;

  GroupType? getPickedVod() => _groupType;

  void pickVod(GroupType groupType) {
    emit(PickingVod());
    _groupType = groupType;
    emit(VodPicked(groupType));
  }

  @override
  void onChange(Change<PickingVodDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
