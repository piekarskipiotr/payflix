import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/repository/firebase_repository.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_state.dart';

@injectable
class InviteDialogCubit extends Cubit<InviteDialogState> {
  final FirebaseRepository _firebaseRepo;
  bool _showSecondary = false;
  bool _showCopiedText = false;

  InviteDialogCubit(this._firebaseRepo) : super(InitInviteDialogState());

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
