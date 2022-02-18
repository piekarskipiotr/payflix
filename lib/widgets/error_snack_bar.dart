import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

SnackBar errorSnackBar(
  BuildContext context,
  String? text,
) {
  return SnackBar(
    content: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(
          Icons.error,
          color: AppColors.creamWhite,
          size: 24.0,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            text ?? getString(context).unexpected_error,
            style: GoogleFonts.nunito(
              color: AppColors.creamWhite,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: AppColors.red,
    duration: const Duration(seconds: 4),
  );
}
