import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';

SnackBar loadingSnackBar(
  BuildContext context,
  String text,
) {
  return SnackBar(
    content: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(
          height: 24.0,
          width: 24.0,
          child: CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 2.0,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.oxygen(
              color: AppColors.creamWhite,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: AppColors.gray,
    duration: const Duration(days: 365),
  );
}
