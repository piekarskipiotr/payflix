import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/signup_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class SignupStateListener {
  static void listenToState(BuildContext context, SignupState state) {
    if (state is SigningUpFailed) {
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          SignupHelper.tryConvertErrorCodeToMessage(
            context,
            state.error,
          ),
        ),
      );
    } else if (state is SigningUpSucceeded) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).sign_up_succeeded_title,
          secondary: getString(context).sign_up_succeeded_secondary,
          animation: lottieSuccess,
          onClick: () => Navigator.pop(context),
        ),
      );
    }
  }
}
