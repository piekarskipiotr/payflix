import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/helpers/error_code_helper.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';
import 'package:payflix/screens/picking_avatar_dialog/ui/picking_avatar_dialog.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/success_snack_bar.dart';

class LoginStateListener {
  static void listenToState(BuildContext context, LoginState state) {
    if (state is LoggingInFailed) {
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
    } else if (state is SignInWithGoogleAccountSucceeded) {
      AppDialogController.showBottomSheetDialog(
        context: context,
        dialog: BlocProvider.value(
          value: context.read<LoginCubit>().getDialogCubit(),
          child: const PickingAvatarDialog(),
        ),
      );
    } else if (state is LoggingInSucceeded) {
      var route = state.doesUserHasGroup ? AppRoutes.home : AppRoutes.welcome;
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    } else if (state is LoggingInWithGoogleAccountSucceeded) {
      var route = state.doesUserHasGroup ? AppRoutes.home : AppRoutes.welcome;
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    } else if (state is NavigateToEmailVerificationRoom) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.verRoom,
        (route) => false,
      );
    } else if (state is SendingPasswordResetEmailFailed) {
      Navigator.pop(context);
      AppDialogController.showSnackBar(
        context,
        errorSnackBar(
          context,
          state.error,
        ),
      );
    } else if (state is SendingPasswordResetEmailSucceeded) {
      Navigator.pop(context);
      AppDialogController.showSnackBar(
        context,
        successSnackBar(
          context,
          getString(context).restart_email_sent_successfully,
        ),
      );
    } else if (state is PopDialog) {
      Navigator.pop(context);
    }
  }
}
