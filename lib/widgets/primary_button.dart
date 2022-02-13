import 'package:flutter/material.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final bool isLoading;

  const PrimaryButton({
    Key? key,
    required this.text,
    required this.onClick,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.buttonGradient,
        borderRadius: AppTheme.buttonBorderRadius,
      ),
      constraints: const BoxConstraints(
        minWidth: 140.0,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onClick,
        child: Padding(
          padding: AppTheme.buttonPadding,
          child: isLoading
              ? const SizedBox(
                  height: 21.0,
                  width: 21.0,
                  child: CircularProgressIndicator(
                    color: AppColors.creamWhite,
                    strokeWidth: 2.0,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: AppColors.creamWhite,
                  ),
                ),
        ),
      ),
    );
  }
}
