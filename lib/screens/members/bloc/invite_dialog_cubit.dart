import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_state.dart';

class InviteDialogCubit extends Cubit<InviteDialogState> {
  bool _showSecondary = false;
  bool _showCopiedText = false;

  InviteDialogCubit() : super(InitInviteDialogState());

  bool showSecondary() => _showSecondary;

  bool showCopiedText() => _showCopiedText;

  void changeView() {
    emit(ChangingDialogView());
    _showSecondary = !_showSecondary;
    emit(DialogViewChanged());
  }

  Future<void> copyInviteLink() async {
    emit(ChangingCopiedTextVisibility());
    Clipboard.setData(
      const ClipboardData(
        text: 'https://payflix.com/invite?=fsadw',
      ),
    );

    _showCopiedText = !_showCopiedText;
    emit(CopiedTextVisibilityChanged());

    await Future.delayed(const Duration(seconds: 3));
    emit(ChangingCopiedTextVisibility());
    _showCopiedText = !_showCopiedText;
    emit(CopiedTextVisibilityChanged());
  }

  @override
  void onChange(Change<InviteDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
