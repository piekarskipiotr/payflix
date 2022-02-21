import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/l10n/l10n.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/resources/routes/routes_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'di/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppTheme.initSystemChromeSettings();
  await Firebase.initializeApp();
  initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payflix',
      debugShowCheckedModeBanner: false,

      // routes
      initialRoute: AppRoutes.login,
      onGenerateRoute: RoutesHandler().getRoute,

      // localization
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],

      // theme
      themeMode: ThemeMode.dark,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
