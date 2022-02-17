import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

SnackBar successSnackBar(
    BuildContext context,
    String text,
    ) {
  return SnackBar(
    content: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        const Icon(
          Icons.check_circle,
          color: AppColors.creamWhite,
          size: 24.0,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.creamWhite,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: AppColors.green,
    duration: const Duration(seconds: 4),
  );
}
