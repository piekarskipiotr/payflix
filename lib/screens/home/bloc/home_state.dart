import 'package:payflix/data/enum/group_type.dart';

abstract class HomeState {
  @override
  String toString() => runtimeType.toString();
}

class InitHomeState extends HomeState {}

class FetchingData extends HomeState {}

class RefreshingData extends HomeState {}

class FetchingDataSucceeded extends HomeState {}

class FetchingDataFailed extends HomeState {}

class VodSelected extends HomeState {}

class LoggingOut extends HomeState {}

class LoggingOutCompleted extends HomeState {}

class NavigateToGroupCreator extends HomeState {
  final GroupType groupType;

  NavigateToGroupCreator(this.groupType);
}

class RefreshingView extends HomeState {}

class ViewRefreshed extends HomeState {}
