import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/helpers/ver_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/loading_snack_bar.dart';
import 'package:payflix/widgets/success_snack_bar.dart';

class VerRoomStateListener {
  static void listenToState(BuildContext context, VerRoomState state) {
    if (state is LoggingOutFinished) {
      _clearSnackBars(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else if (state is ResendingVerificationEmail) {
      AppDialogController.showSnackBar(
        context,
        loadingSnackBar(
          context,
          getString(context).sending_verification_email,
        ),
      );
    } else if (state is ResendingVerificationEmailSucceeded) {
      _clearSnackBars(context);
      AppDialogController.showSnackBar(
        context,
        successSnackBar(
          context,
          getString(context).sending_verification_email_succeeded,
        ),
      );
    } else if (state is ResendingVerificationEmailFailed) {
      _clearSnackBars(context);
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          VerHelper.tryConvertErrorCodeToMessage(
            context,
            state.error,
          ),
        ),
      );
    } else if (state is EmailVerificationSucceeded) {
      _clearSnackBars(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    }
  }

  static void _clearSnackBars(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
