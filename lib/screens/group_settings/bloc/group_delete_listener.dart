import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/error_code_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/group_settings/bloc/group_delete_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class GroupDeleteStateListener {
  static void listenToState(BuildContext context, GroupDeleteState state) {
   if (state is DeletingGroupSucceeded) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).group_deleted,
          secondary: getString(context).group_deleted_body,
          animation: lottieSuccess2,
          onClick: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
                (route) => false,
          ),
        ),
      );
    } else if (state is DeletingGroupFailed) {
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
