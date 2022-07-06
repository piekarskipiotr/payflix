import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/joining_group_dialog/ui/joining_group_dialog.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';

class LaunchingScreenListener {
  static void listenToState(
    BuildContext context,
    LaunchingScreenState state,
    JoiningGroupDialogCubit joiningGroupDialogCubit,
  ) {
    if (state is StartingApp) {
      var route = state.route;
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    } else if (state is UserIsAlreadyInThisGroup) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          getString(context).user_already_in_group,
        ),
      );
    } else if (state is UserIsAlreadyInThisVodGroup) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        errorSnackBar(
          context,
          getString(context).user_already_in_vod_group_type,
        ),
      );
    } else if (state is UserCanBeAddedToTheGroup) {
      ScaffoldMessenger.of(context).clearSnackBars();
      AppDialogController.showFullScreenDialog(
        context,
        BlocProvider.value(
          value: joiningGroupDialogCubit,
          child: JoiningGroupDialog(
            adminEmailId: state.email, groupId: state.groupId, uid: state.uid,
          ),
        ),
      );
    } else if (state is AddingUserToGroupCompleted) {
      AppDialogController.showFullScreenDialog(
        context,
        FullScreenDialog(
          title: getString(context).added_to_group_successfully,
          animation: lottieSuccess2,
          onClick: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
        ),
      );
    }
  }
}
