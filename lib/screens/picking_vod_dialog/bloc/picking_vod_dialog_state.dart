import 'package:payflix/data/enum/group_type.dart';

abstract class PickingVodDialogState {}

class InitPickingVodDialogState extends PickingVodDialogState {
  @override
  String toString() => runtimeType.toString();
}

class PickingVod extends PickingVodDialogState {
  @override
  String toString() => runtimeType.toString();
}

class VodPicked extends PickingVodDialogState {
  final GroupType groupType;

  VodPicked(this.groupType);

  @override
  String toString() => runtimeType.toString();
}
