import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';
import 'package:payflix/widgets/error_snack_bar.dart';

class LaunchingScreenListener {
  static void listenToState(BuildContext context, LaunchingScreenState state) {
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
    }
  }
}
