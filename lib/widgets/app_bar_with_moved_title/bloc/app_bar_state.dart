abstract class AppBarState {
  @override
  String toString() => runtimeType.toString();
}

class InitAppBarState extends AppBarState {}

class ChangingVisibilityOfRegularTitle extends AppBarState {}

class VisibilityOfRegularTitleChanged extends AppBarState {}
