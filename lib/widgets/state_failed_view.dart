import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/widgets/primary_button.dart';

class StateFailedView extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const StateFailedView({
    Key? key,
    required this.text,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.red,
            size: 48.0,
          ),
          const SizedBox(
            height: 6.0,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.oxygen(
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
              color: AppColors.creamWhite,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(
            height: 28.0,
          ),
          PrimaryButton(
            text: getString(context).reload,
            onClick: onClick,
            isLoading: false,
          ),
          const SizedBox(
            height: 48.0,
          ),
        ],
      ),
    );
  }
}
