import 'package:flutter/material.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeCubitListener {
  static listenToState(
    BuildContext context,
    HomeState state,
    RefreshController groupsController,
    RefreshController profileController,
  ) {
    if (state is NavigateToGroupCreator) {
      var vod = state.groupType;

      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.groupSettings,
        arguments: [true, vod],
      );
    } else if (state is LoggingOutCompleted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
        (route) => false,
      );
    } else if (state is FetchingDataSucceeded) {
      if (groupsController.isRefresh) {
        groupsController.refreshCompleted();
      }

      if (profileController.isRefresh) {
        profileController.refreshCompleted();
      }
    } else if (state is FetchingDataFailed) {
      if (groupsController.isRefresh) {
        groupsController.refreshFailed();
      }

      if (profileController.isRefresh) {
        profileController.refreshFailed();
      }
    }
  }
}
