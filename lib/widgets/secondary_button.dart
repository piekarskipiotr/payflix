import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final bool isLoading;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onClick,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineGradientButton(
      padding: AppTheme.buttonPadding,
      gradient: AppTheme.buttonGradient,
      radius: AppTheme.buttonRadius,
      strokeWidth: 2.0,
      inkWell: true,
      onTap: isLoading ? null : onClick,
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 110.0,
        ),
        child: isLoading
            ? const FittedBox(
                fit: BoxFit.scaleDown,
                child: SizedBox(
                  height: 21.0,
                  width: 21.0,
                  child: CircularProgressIndicator(
                    color: AppColors.creamWhite,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppColors.creamWhite,
                ),
              ),
      ),
    );
  }
}
