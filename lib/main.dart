import 'package:flutter/material.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/resources/routes/routes_handler.dart';

void main() {
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
      initialRoute: AppRoutes.playground,
      onGenerateRoute: RoutesHandler().getRoute,

      // theme
      themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
