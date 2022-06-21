import 'package:flutter/widgets.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/error_code_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/ui/profile/bloc/change_password_dialog_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class ChangePasswordDialogStateListener {
  static listenToState(BuildContext context, ChangePasswordDialogState state) {
    if (state is ChangingUserPasswordFailed) {
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          state.error == 'wrong-password'
              ? getString(context).wrong_previous_password
              : ErrorCodeHelper.tryConvertErrorCodeToMessage(
                  context,
                  state.error,
                ),
        ),
      );
    } else if (state is ChangingUserPasswordSucceeded) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).password_changed_successfully,
          animation: lottieSuccess2,
          onClick: () => Navigator.popUntil(
            context,
            ModalRoute.withName(
              AppRoutes.home,
            ),
          ),
        ),
      );
    }
  }
}
