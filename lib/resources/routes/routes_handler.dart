import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/app_listener_bloc/app_listener_cubit.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_cubit.dart';
import 'package:payflix/screens/group_settings/ui/group_settings.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/ui/home.dart';
import 'package:payflix/screens/home/ui/profile/app-info/acknowledgments.dart';
import 'package:payflix/screens/home/ui/profile/app-info/changelog.dart';
import 'package:payflix/screens/home/ui/profile/app-info/support.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_cubit.dart';
import 'package:payflix/screens/launching_screen/ui/launching_screen.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/ui/login.dart';
import 'package:payflix/screens/members/bloc/members_cubit.dart';
import 'package:payflix/screens/members/ui/members.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_cubit.dart';
import 'package:payflix/screens/qr_scanner/ui/qr_scanner.dart';
import 'package:payflix/screens/signup/bloc/signup_cubit.dart';
import 'package:payflix/screens/signup/ui/sign_up.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_cubit.dart';
import 'package:payflix/screens/verification_room/ui/ver_room.dart';
import 'package:payflix/screens/welcome/bloc/welcome_cubit.dart';
import 'package:payflix/screens/welcome/ui/welcome.dart';

@injectable
class RoutesHandler {
  Route? getRoute(RouteSettings settings) {
    log('Routing to: ${settings.name}', name: '$runtimeType');

    switch (settings.name) {
      case AppRoutes.launch:
        return buildRoute(
          BlocProvider.value(
            value: getIt<LaunchingScreenCubit>(),
            child: const LaunchingScreen(),
          ),
          settings: settings,
        );
      case AppRoutes.login:
        return buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AppListenerCubit>()),
              BlocProvider.value(
                value: getIt<LoginCubit>(),
              )
            ],
            child: Login(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.signUp:
        return buildRoute(
          BlocProvider.value(
            value: getIt<SignUpCubit>(),
            child: SignUp(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.verRoom:
        return buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AppListenerCubit>()),
              BlocProvider.value(
                value: getIt<VerRoomCubit>()..listenToVerificationStatus(),
              ),
            ],
            child: const VerificationRoom(),
          ),
          settings: settings,
        );
      case AppRoutes.welcome:
        return buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<AppListenerCubit>()),
              BlocProvider.value(
                value: getIt<WelcomeCubit>()..isAlreadyInGroup(),
              ),
            ],
            child: const Welcome(),
          ),
          settings: settings,
        );
      case AppRoutes.groupSettings:
        return buildRoute(
          BlocProvider.value(
            value: getIt<GroupSettingsCubit>(),
            child: GroupSettings(
              formKey: GlobalKey<FormState>(),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.members:
        return buildRoute(
          BlocProvider.value(
            value: getIt<MembersCubit>(),
            child: const Members(),
          ),
          settings: settings,
        );
      case AppRoutes.home:
        return buildRoute(
          MultiBlocProvider(
            providers: [
              BlocProvider.value(value: getIt<HomeCubit>()),
              BlocProvider.value(value: getIt<AppListenerCubit>()),
            ],
            child: const Home(),
          ),
          settings: settings,
        );
      case AppRoutes.qrScanner:
        return buildRoute(
          BlocProvider.value(
            value: getIt<QrScannerCubit>(),
            child: const QrScanner(),
          ),
          settings: settings,
        );
      case AppRoutes.acknow:
        return buildRoute(
          const Acknowledgments(),
          settings: settings,
        );
      case AppRoutes.support:
        return buildRoute(
          const Support(),
          settings: settings,
        );
      case AppRoutes.changelog:
        return buildRoute(
          const Changelog(),
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
