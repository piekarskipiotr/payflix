import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class Changelog extends StatelessWidget {
  const Changelog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getString(context).change_log,
          style: GoogleFonts.oxygen(
            fontSize: 18.0,
            color: AppColors.creamWhite,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 48.0,
            ),
            Center(
              child: Image.asset(
                womenSittingWithLaptop,
                height: 224.0,
                width: 224.0,
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
              ),
              child: Text(
                getString(context).changelog_title,
                style: GoogleFonts.oxygen(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.creamWhite,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
              ),
              child: Text(
                getString(context).changelog_subtitle,
                style: GoogleFonts.oxygen(
                  fontSize: 18.0,
                  color: AppColors.creamWhite,
                ),
              ),
            ),
            const SizedBox(
              height: 36.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
              ),
              child: Text(
                getString(context).app_version('1.0.0'),
                style: GoogleFonts.oxygen(
                  fontSize: 18.0,
                  color: AppColors.creamWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                ),
                child: Column(
                  children: [
                    UnorderedItem(text: getString(context).release),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class UnorderedItem extends StatelessWidget {
  final String text;

  const UnorderedItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text('➡️ '),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.oxygen(
              fontSize: 16.0,
              color: AppColors.creamWhite,
            ),
          ),
        ),
      ],
    );
  }
}
