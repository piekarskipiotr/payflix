import 'package:flutter/material.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state.dart';

class WelcomeStateListener {
  static void listenToState(BuildContext context, WelcomeState state) {
    if (state is NavigateToGroup) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
        arguments: state.group
      );
    }
  }
}
