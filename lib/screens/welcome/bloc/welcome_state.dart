import 'package:payflix/data/model/group.dart';

abstract class WelcomeState {}

class InitWelcomeState extends WelcomeState {
  @override
  String toString() => runtimeType.toString();
}

class NavigateToGroup extends WelcomeState {
  final Group group;

  NavigateToGroup(this.group);

  @override
  String toString() => runtimeType.toString();
}
