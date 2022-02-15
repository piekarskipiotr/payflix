import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'package:payflix/screens/sign_up/bloc/sign_up_cubit.dart';
import 'package:payflix/screens/sign_up/ui/sign_up.dart';

class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(
          const Login(),
          settings: settings,
        );
      case AppRoutes.signUp:
        return buildRoute(
          BlocProvider(
            create: (_) => SignUpCubit(),
            child: SignUp(
              formKey: GlobalKey<FormState>(),
            ),
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
