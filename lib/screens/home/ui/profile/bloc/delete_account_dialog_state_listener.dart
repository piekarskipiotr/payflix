import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/error_code_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/ui/profile/bloc/delete_account_dialog_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class DeleteAccountDialogStateListener {
  static void listenToState(BuildContext context, DeleteAccountDialogState state) {
    if (state is DeletingAccountSucceeded) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).account_deleted,
          secondary: getString(context).account_deleted_body,
          animation: lottieSuccess2,
          onClick: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
                (route) => false,
          ),
        ),
      );
    } else if (state is DeletingAccountFailed) {
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          ErrorCodeHelper.tryConvertErrorCodeToMessage(
            context,
            state.error,
          ),
        ),
      );
    }
  }
}
