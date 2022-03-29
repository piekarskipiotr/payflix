import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_cubit.dart';
import 'package:payflix/screens/group_settings/ui/group_settings.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'package:payflix/screens/members/bloc/members_cubit.dart';
import 'package:payflix/screens/members/ui/members.dart';
import 'package:payflix/screens/signup/bloc/signup_cubit.dart';
import 'package:payflix/screens/signup/ui/sign_up.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_cubit.dart';
import 'package:payflix/screens/verification_room/ui/ver_room.dart';
import 'package:payflix/screens/welcome/bloc/welcome_cubit.dart';
import 'package:payflix/screens/welcome/ui/welcome.dart';

@injectable
class RoutesHandler {
  final AuthRepository _authRepository;

  RoutesHandler(this._authRepository);

  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.login:
        return buildRoute(
          BlocProvider(
            create: (_) => getIt<LoginCubit>(),
            child: Login(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.signUp:
        return buildRoute(
          BlocProvider(
            create: (_) => getIt<SignUpCubit>(),
            child: SignUp(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.verRoom:
        return buildRoute(
          BlocProvider(
            create: (_) => getIt<VerRoomCubit>()..listenToVerificationStatus(),
            child: const VerificationRoom(),
          ),
          settings: settings,
        );
      case AppRoutes.welcome:
        return buildRoute(
          BlocProvider(
            create: (_) => getIt<WelcomeCubit>()..isAlreadyInGroup(),
            child: const Welcome(),
          ),
          settings: settings,
        );
      case AppRoutes.groupSettings:
        return buildRoute(
          BlocProvider(
            create: (_) => getIt<GroupSettingsCubit>(),
            child: GroupSettings(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.members:
        return buildRoute(
          BlocProvider(
              create: (_) => getIt<MembersCubit>(),
              child: const Members()),
          settings: settings,
        );
    }

    return null;
  }

  String getInitialRoute() {
    var user = _authRepository.instance().currentUser;
    bool isAuth = user != null;
    bool isVerified = user?.emailVerified == true;

    if (isAuth && isVerified) {
      return AppRoutes.members;
    } else if (isAuth && !isVerified) {
      return AppRoutes.verRoom;
    } else {
      return AppRoutes.login;
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
