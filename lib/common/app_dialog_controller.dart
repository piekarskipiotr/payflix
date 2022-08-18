import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class AppDialogController {
  static showSnackBar(BuildContext context, SnackBar snackBar) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showFullScreenDialog(BuildContext context, Widget dialog) {
    Navigator.of(context).push(
      PageRouteBuilder(opaque: false, pageBuilder: (context, _, __) => dialog),
    );
  }

  static showBottomSheetDialog({
    required BuildContext context,
    required Widget dialog,
    bool isSidePadding = true,
  }) {
    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(34.0),
          topLeft: Radius.circular(34.0),
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
              padding: isSidePadding
                  ? const EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                    )
                  : EdgeInsets.zero,
              child: dialog,
            ),
          ),
        ),
      ),
    );
  }
}
