import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'colors/color_helper.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorDark: AppColors.secondary,
    primarySwatch: ColorHelper.toMaterialColor(AppColors.primary),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.secondary,
    ),
    scaffoldBackgroundColor: AppColors.black,
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        color: AppColors.creamWhite,
      ),
      systemOverlayStyle:
          SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: buttonBorderRadius,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldBlack,
      prefixIconColor: AppColors.creamWhite,
      suffixIconColor: AppColors.creamWhite,
      errorStyle: TextStyle(
        color: AppColors.red,
      ),
      contentPadding: EdgeInsets.only(
        left: 15.0,
        top: 17.0,
        right: 15.0,
        bottom: 17.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.fieldBlack,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            18.0,
          ),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            18.0,
          ),
        ),
      ),
    ),
    toggleableActiveColor: AppColors.accent,
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all<Color>(AppColors.black),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
  );

  // buttons settings
  static const buttonPadding = EdgeInsets.only(
    left: 10.0,
    top: 17.0,
    right: 10.0,
    bottom: 17.0,
  );

  static final buttonBorderRadius = BorderRadius.circular(
    28.0,
  );

  static const buttonRadius = Radius.circular(
    28.0,
  );

  static final buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary.withOpacity(0.98),
      AppColors.secondary.withOpacity(0.92),
      AppColors.secondaryDarker.withOpacity(0.9),
    ],
  );

  static final welcomeGradientExperimental = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.black.withOpacity(0.0),
      AppColors.black.withOpacity(0.02),
      AppColors.black.withOpacity(0.04),
      AppColors.black.withOpacity(0.06),
      AppColors.black.withOpacity(0.08),
      AppColors.black.withOpacity(0.10),
      AppColors.black.withOpacity(0.20),
      AppColors.black.withOpacity(0.30),
      AppColors.black.withOpacity(0.40),
      AppColors.black.withOpacity(0.50),
      AppColors.black.withOpacity(0.60),
      AppColors.black.withOpacity(0.70),
      AppColors.black.withOpacity(0.80),
      AppColors.black.withOpacity(0.90),
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
    ],
  );

  static final memberTextOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.black.withOpacity(0.0),
      Colors.black.withOpacity(0.01),
      Colors.black.withOpacity(0.02),
      Colors.black.withOpacity(0.04),
      Colors.black.withOpacity(0.06),
      Colors.black.withOpacity(0.08),
      Colors.black.withOpacity(0.10),
      Colors.black.withOpacity(0.20),
      Colors.black.withOpacity(0.30),
      Colors.black.withOpacity(0.40),
      Colors.black.withOpacity(0.50),
      Colors.black.withOpacity(0.60),
      Colors.black.withOpacity(0.70),
      Colors.black.withOpacity(0.80),
      Colors.black.withOpacity(0.90),
      Colors.black.withOpacity(0.92),
      Colors.black.withOpacity(0.94),
      Colors.black.withOpacity(0.96),
      Colors.black.withOpacity(0.98),
      Colors.black,
    ],
  );

  static LinearGradient paymentsBottomOverlayGradient(Color color) => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      color.withOpacity(0.0),
      color.withOpacity(0.01),
      color.withOpacity(0.02),
      color.withOpacity(0.04),
      color.withOpacity(0.06),
      color.withOpacity(0.08),
      color.withOpacity(0.10),
      color.withOpacity(0.20),
      color.withOpacity(0.30),
      color.withOpacity(0.40),
      color.withOpacity(0.50),
      color.withOpacity(0.60),
      color.withOpacity(0.70),
      color.withOpacity(0.80),
      color.withOpacity(0.90),
      color.withOpacity(0.92),
      color.withOpacity(0.94),
      color.withOpacity(0.96),
      color.withOpacity(0.98),
      color,
    ],
  );

  static final appBarGradientExperimental = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black,
      AppColors.black.withOpacity(0.98),
      AppColors.black.withOpacity(0.96),
      AppColors.black.withOpacity(0.94),
      AppColors.black.withOpacity(0.92),
      AppColors.black.withOpacity(0.90),
      AppColors.black.withOpacity(0.80),
      AppColors.black.withOpacity(0.70),
      AppColors.black.withOpacity(0.60),
      AppColors.black.withOpacity(0.50),
      AppColors.black.withOpacity(0.40),
      AppColors.black.withOpacity(0.30),
      AppColors.black.withOpacity(0.20),
      AppColors.black.withOpacity(0.10),
      AppColors.black.withOpacity(0.08),
      AppColors.black.withOpacity(0.06),
      AppColors.black.withOpacity(0.04),
      AppColors.black.withOpacity(0.02),
      AppColors.black.withOpacity(0.01),
      AppColors.black.withOpacity(0.0),
    ],
  );

  static final disabledButtonGradient = LinearGradient(
    colors: [
      AppColors.gray.withOpacity(0.98),
      AppColors.lighterGray.withOpacity(0.90),
    ],
  );

  static void initSystemChromeSettings() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top],
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}
