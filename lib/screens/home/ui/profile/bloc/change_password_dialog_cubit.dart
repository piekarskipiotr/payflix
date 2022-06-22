import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/screens/home/ui/profile/bloc/change_password_dialog_state.dart';

@injectable
class ChangePasswordDialogCubit extends Cubit<ChangePasswordDialogState> {
  final AuthRepository _authRepository;

  bool _isPreviousPasswordObscure = true;
  bool _isNewPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  String? _previousPassword;
  String? _newPassword;
  String? _confirmPassword;

  ChangePasswordDialogCubit(this._authRepository)
      : super(InitChangePasswordDialogState());

  bool isPreviousPasswordVisible() => _isPreviousPasswordObscure;

  bool isNewPasswordVisible() => _isNewPasswordObscure;

  bool isConfirmPasswordVisible() => _isConfirmPasswordObscure;

  void changePreviousPasswordVisibility() {
    emit(ChangingPasswordVisibility());
    _isPreviousPasswordObscure = !_isPreviousPasswordObscure;
    emit(PasswordVisibilityChanged());
  }

  void changeNewPasswordVisibility() {
    emit(ChangingPasswordVisibility());
    _isNewPasswordObscure = !_isNewPasswordObscure;
    emit(PasswordVisibilityChanged());
  }

  void changeConfirmPasswordVisibility() {
    emit(ChangingPasswordVisibility());
    _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
    emit(PasswordVisibilityChanged());
  }

  String? getPreviousPassword() => _previousPassword;

  String? getNewPassword() => _newPassword;

  String? getConfirmPassword() => _confirmPassword;

  void setPreviousPassword(String? password) => _previousPassword = password;

  void setNewPassword(String? password) => _newPassword = password;

  void setConfirmPassword(String? password) => _confirmPassword = password;

  Future changePassword() async {
    emit(ChangingUserPassword());
    var user = _authRepository.instance().currentUser;
    if (user != null) {
      try {
        await user.reauthenticateWithCredential(
          EmailAuthProvider.credential(
            email: user.email!,
            password: getPreviousPassword()!,
          ),
        );

        await user.updatePassword(getNewPassword()!);
        emit(ChangingUserPasswordSucceeded());
      } on FirebaseAuthException catch (e) {
        emit(ChangingUserPasswordFailed(e.code));
      } catch (_) {
        emit(ChangingUserPasswordFailed('other'));
      }
    } else {
      emit(ChangingUserPasswordFailed('user-not-found'));
    }
  }

  @override
  void onChange(Change<ChangePasswordDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
