import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/playground.dart';
import 'package:payflix/screens/login/bloc/login_bloc.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'package:payflix/screens/registration/bloc/registration_bloc.dart';
import 'package:payflix/screens/registration/ui/registration.dart';
import 'app_routes.dart';

class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.playground:
        return buildRoute(const Playground(), settings: settings);
      case AppRoutes.login:
        return buildRoute(
          BlocProvider(
            create: (_) => LoginBloc(),
            child: Login(formKey: GlobalKey<FormState>(),),
          ),
          settings: settings,
        );
      case AppRoutes.registration:
        return buildRoute(
          BlocProvider(
            create: (_) => RegistrationBloc(),
            child: Registration(formKey: GlobalKey<FormState>(),),
          ),
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
