import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/login/ui/login.dart';

class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(
          const Login(),
          settings: settings,
        );
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
