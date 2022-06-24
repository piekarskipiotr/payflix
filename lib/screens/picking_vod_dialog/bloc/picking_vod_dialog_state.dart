import 'package:payflix/data/enum/group_type.dart';

abstract class PickingVodDialogState {
  @override
  String toString() => runtimeType.toString();
}

class InitPickingVodDialogState extends PickingVodDialogState {}

class PickingVod extends PickingVodDialogState {}

class VodPicked extends PickingVodDialogState {
  final GroupType groupType;

  VodPicked(this.groupType);
}
