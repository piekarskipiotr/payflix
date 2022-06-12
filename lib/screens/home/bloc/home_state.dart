import 'package:payflix/data/enum/group_type.dart';

abstract class HomeState {}

class InitHomeState extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingData extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class FetchingDataSucceeded extends HomeState {
    @override
  String toString() => runtimeType.toString();
}

class FetchingDataFailed extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class VodSelected extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingOut extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class LoggingOutCompleted extends HomeState {
  @override
  String toString() => runtimeType.toString();
}

class NavigateToGroupCreator extends HomeState {
  final GroupType groupType;

  NavigateToGroupCreator(this.groupType);

  @override
  String toString() => runtimeType.toString();
}