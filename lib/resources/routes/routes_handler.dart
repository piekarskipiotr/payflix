import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:payflix/playground.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'app_routes.dart';

class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');
    switch (settings.name) {
      case AppRoutes.playground:
        return buildRoute(const Playground(), settings: settings);
      case AppRoutes.login:
        return buildRoute(const Login(), settings: settings);
    }
  }

  MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => child,
    );
  }
}
