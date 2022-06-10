abstract class AppBarState {}

class InitAppBarState extends AppBarState {
  @override
  String toString() => runtimeType.toString();
}

class ChangingVisibilityOfRegularTitle extends AppBarState {
  @override
  String toString() => runtimeType.toString();
}

class VisibilityOfRegularTitleChanged extends AppBarState {
  @override
  String toString() => runtimeType.toString();
}