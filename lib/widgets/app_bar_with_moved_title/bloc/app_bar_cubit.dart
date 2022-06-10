import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_state.dart';

@injectable
class AppBarCubit extends Cubit<AppBarState> {
  bool _showRegularTitle = false;
  AppBarCubit() : super(InitAppBarState());

  bool showRegularTitle() => _showRegularTitle;

  void handleTitle(double top) {
    if (top < regularTitleTopValue - 5.0 && !showRegularTitle()) {
      emit(ChangingVisibilityOfRegularTitle());
      _showRegularTitle = true;
      emit(VisibilityOfRegularTitleChanged());
    } else if (top > regularTitleTopValue && showRegularTitle()) {
      emit(ChangingVisibilityOfRegularTitle());
      _showRegularTitle = false;
      emit(VisibilityOfRegularTitleChanged());
    }
  }

  @override
  void onChange(Change<AppBarState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
