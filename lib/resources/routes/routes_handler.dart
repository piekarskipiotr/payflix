import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'package:payflix/screens/signup/bloc/signup_cubit.dart';
import 'package:payflix/screens/signup/ui/sign_up.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_cubit.dart';
import 'package:payflix/screens/verification_room/ui/ver_room.dart';

class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(
          BlocProvider(
            create: (_) => LoginCubit(),
            child: Login(
              formKey: GlobalKey<FormState>(),
            ),
          ),
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
      case AppRoutes.verRoom:
        return buildRoute(
          BlocProvider(
            create: (_) => VerRoomCubit(),
            child: const VerificationRoom(),
          ),
          settings: settings,
        );
    }

    return null;
  }

  MaterialPageRoute buildRoute(Widget child,
      {required RouteSettings settings}) {
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => child,
    );
  }
}
