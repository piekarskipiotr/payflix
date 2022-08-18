import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_state.dart';

@injectable
class GroupQuickActionsDialogCubit extends Cubit<GroupQuickActionsDialogState> {
  bool _showSecondary = false;

  GroupQuickActionsDialogCubit() : super(InitGroupQuickActionsDialogState());

  bool showSecondary() => _showSecondary;

  void changeView() {
    emit(ChangingDialogView());
    _showSecondary = !_showSecondary;
    emit(DialogViewChanged());
  }

  @override
  void onChange(Change<GroupQuickActionsDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}