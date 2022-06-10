import 'package:flutter/material.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';

class HomeCubitListener {
  static listenToState(BuildContext context, HomeState state) {
    if (state is NavigateToGroupCreator) {
      var vod = state.groupType;

      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.groupSettings,
        arguments: [true, vod],
      );
    }
  }
}
