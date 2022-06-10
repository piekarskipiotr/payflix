import 'package:payflix/data/enum/group_type.dart';

abstract class HomeState {}

class InitHomeState extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingGroups extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingGroupsSucceeded extends HomeState {
    @override
  String toString() => runtimeType.toString();
}

class FetchingGroupsFailed extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class VodSelected extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class NavigateToGroupCreator extends HomeState {
  final GroupType groupType;

  NavigateToGroupCreator(this.groupType);

  @override
  String toString() => runtimeType.toString();
}