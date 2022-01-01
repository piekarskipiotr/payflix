import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'colors/color_helper.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      primaryColor: AppColors.primary,
      primaryColorDark: AppColors.primaryDark,
      primarySwatch: ColorHelper.toMaterialColor(AppColors.primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(AppColors.lightGray),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
          ),
        ),
      ));

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorDark: AppColors.primaryDark,
    primarySwatch: ColorHelper.toMaterialColor(AppColors.primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(AppColors.lightGray),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
        ),
      ),
    ),
  );
}
