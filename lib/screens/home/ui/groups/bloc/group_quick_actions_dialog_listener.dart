import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/success_snack_bar.dart';

class GroupQuickActionsDialogListener {
  static listenToState(
    BuildContext context,
    GroupQuickActionsDialogState state,
  ) {
    if (state is LeavingGroupSucceeded) {
      Navigator.pop(context);
      AppDialogController.showSnackBar(
        context,
        successSnackBar(
          context,
          getString(context).leaving_group_succeeded,
        ),
      );
    } else if (state is LeavingGroupFailed) {
      Navigator.pop(context);
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          getString(context).leaving_group_failed,
        ),
      );
    }
  }
}
