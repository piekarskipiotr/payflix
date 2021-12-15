import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

import 'colors/color_helper.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorDark: AppColors.primaryDark,
    primarySwatch: ColorHelper.toMaterialColor(AppColors.primary),
  );

  static final darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    primaryColorDark: AppColors.primaryDark,
    primarySwatch: ColorHelper.toMaterialColor(AppColors.primary),
  );
}
