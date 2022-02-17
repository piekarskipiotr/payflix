import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/sign_up_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/sign_up/bloc/sign_up_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class SignUpStateListener {
  static void listenToState(BuildContext context, SignUpState state) {
    if (state is SigningUpFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          SignUpHelper.tryConvertErrorCodeToMessage(
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
