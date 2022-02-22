import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_cubit.dart';
import 'package:payflix/screens/group_settings/ui/group_settings.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'package:payflix/screens/signup/bloc/signup_cubit.dart';
import 'package:payflix/screens/signup/ui/sign_up.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_cubit.dart';
import 'package:payflix/screens/verification_room/ui/ver_room.dart';
import 'package:payflix/screens/welcome/bloc/welcome_cubit.dart';
import 'package:payflix/screens/welcome/ui/welcome.dart';

class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(
          BlocProvider(
            create: (_) => LoginCubit(
              getIt<FirebaseAuth>(),
              getIt<FirebaseFirestore>(),
            ),
            child: Login(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.signUp:
        return buildRoute(
          BlocProvider(
            create: (_) => SignUpCubit(
              getIt<FirebaseAuth>(),
              getIt<FirebaseFirestore>(),
            ),
            child: SignUp(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.verRoom:
        return buildRoute(
          BlocProvider(
            create: (_) => VerRoomCubit(
              getIt<FirebaseAuth>(),
            )..listenToVerificationStatus(),
            child: const VerificationRoom(),
          ),
          settings: settings,
        );
      case AppRoutes.welcome:
        return buildRoute(
          BlocProvider(
            create: (_) => WelcomeCubit(),
            child: const Welcome(),
          ),
          settings: settings,
        );
      case AppRoutes.groupSettings:
        return buildRoute(
          BlocProvider(
            create: (_) => GroupSettingsCubit(
              getIt<FirebaseAuth>(),
              getIt<FirebaseFirestore>(),
            ),
            child: GroupSettings(
              formKey: GlobalKey<FormState>(),
            ),
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
