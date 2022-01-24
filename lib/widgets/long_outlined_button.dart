import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

class LongOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final bool isLoading;
  final Color? customLoadingCircleColor;
  final ButtonStyle? customStyle;

  const LongOutlinedButton({
    Key? key,
    required this.text,
    required this.onClick,
    required this.isLoading,
    this.customLoadingCircleColor,
    this.customStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: customStyle,
        onPressed: isLoading ? () {} : onClick,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading
              ? SizedBox(
            height: 16.0,
            width: 16.0,
            child: CircularProgressIndicator(
              color: customLoadingCircleColor ?? Colors.white,
            ),
          )
              : Text(
            text,
            style: const TextStyle(
              fontSize: 17.0,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
