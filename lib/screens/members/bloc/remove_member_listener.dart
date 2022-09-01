import 'package:flutter/material.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/error_code_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/members/bloc/remove_member_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class RemoveMemberListener {
  static listenToState(
    BuildContext context,
    RemoveMemberState state,
    HomeCubit homeCubit,
  ) {
    if (state is RemovingMemberSucceeded) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).member_removed,
          secondary: getString(context).member_removed_body,
          animation: lottieSuccess2,
          onClick: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.members,
            ModalRoute.withName(AppRoutes.home),
            arguments: [state.group, homeCubit]
          ),
        ),
      );
    } else if (state is RemovingMemberFailed) {
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

      Navigator.pop(context);
    }
  }
}
