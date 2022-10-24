import 'package:payflix/data/model/group.dart';

abstract class WelcomeState {
  @override
  String toString() => runtimeType.toString();
}

class InitWelcomeState extends WelcomeState {}

class NavigateToGroup extends WelcomeState {
  final Group group;

  NavigateToGroup(this.group);
}

class CheckingWelcomeState extends WelcomeState {}

class CheckingWelcomeStateCompleted extends WelcomeState {}