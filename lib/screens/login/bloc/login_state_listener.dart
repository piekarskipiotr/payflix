import 'package:flutter/material.dart';
import 'package:payflix/common/helpers/login_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/success_snack_bar.dart';

class LoginStateListener {
  static void listenToState(BuildContext context, LoginState state) {
    if (state is LoggingInFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          LoginHelper.tryConvertErrorCodeToMessage(
            context,
            state.error,
          ),
        ),
      );
    } else if (state is LoggingInSucceeded) {
    } else if (state is NavigateToEmailVerificationRoom) {
    } else if (state is SendingPasswordResetEmailFailed) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          state.error,
        ),
      );
    } else if (state is SendingPasswordResetEmailSucceeded) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        successSnackBar(
          context,
          getString(context).restart_email_sent_successfully,
        ),
      );
    }
  }
}
