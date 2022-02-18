import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class FullScreenDialog extends StatelessWidget {
  final String title;
  final String? secondary;
  final String animation;
  final VoidCallback onClick;

  const FullScreenDialog({
    Key? key,
    required this.title,
    this.secondary,
    required this.animation,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 35.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oxygen(
                        fontSize: 38.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.creamWhite,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    width: 162.0,
                    height: 162.0,
                    child: Lottie.asset(animation, repeat: false),
                  ),
                  if (secondary != null) ...[
                    const SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Text(
                        secondary!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxygen(
                          color: AppColors.creamWhite,
                          fontSize: 16.0,
                        ),
                      ),
                    )
                  ]
                ],
              ),
              const Spacer(),
              ListTile(
                onTap: onClick,
                title: Text(
                  getString(context).close_dialog,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oxygen(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: AppColors.creamWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
