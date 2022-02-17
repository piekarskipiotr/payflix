import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class AppDialogHelper {
  static showFullScreenDialog(BuildContext context, Widget dialog) {
    Navigator.of(context).push(
      PageRouteBuilder(opaque: false, pageBuilder: (context, _, __) => dialog),
    );
  }

  static showBottomSheetDialog(BuildContext context, Widget dialog) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(28.0),
          topLeft: Radius.circular(28.0),
        ),
      ),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5.0,
          sigmaY: 5.0,
        ),
        child: Container(
          color: AppColors.containerBlack,
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: dialog,
            ),
          ),
        ),
      ),
    );
  }
}
