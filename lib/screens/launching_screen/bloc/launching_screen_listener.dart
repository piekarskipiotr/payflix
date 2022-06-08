import 'package:flutter/material.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

class LaunchingScreenListener {
  static void listenToState(BuildContext context, LaunchingScreenState state) {
    if (state is StartingApp) {
      var route = state.route;
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }
}