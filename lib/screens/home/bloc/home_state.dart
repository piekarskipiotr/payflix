import 'package:payflix/data/model/group.dart';

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
  List<Group> groups;

  FetchingGroupsSucceeded(this.groups);

  @override
  String toString() => runtimeType.toString();
}

class FetchingGroupsFailed extends HomeState {
  @override
  String toString() => runtimeType.toString();
}