import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/url_helper.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class Acknowledgments extends StatelessWidget {
  const Acknowledgments({Key? key}) : super(key: key);

  // Illustration by "https://icons8.com/illustrations/author/zD2oqC8lLBBA"
  // from "https://icons8.com/illustrations"

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getString(context).acknowledgments,
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
                joyfulMan,
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
                getString(context).acknowledgments_humans_title,
                style: GoogleFonts.oxygen(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.creamWhite,
                ),
              ),
            ),
            const SizedBox(
              height: 38.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
              ),
              child: RichText(
                text: TextSpan(
                  text: 'Illustrations by ',
                  style: GoogleFonts.oxygen(
                    fontSize: 16.0,
                    color: AppColors.creamWhite,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Icons 8',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => UrlHelper.openUrl(
                            'https://icons8.com/illustrations/author/zD2oqC8lLBBA'),
                      style: GoogleFonts.oxygen(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: AppColors.orange,
                      ),
                    ),
                    const TextSpan(
                      text: '\nfrom ',
                    ),
                    TextSpan(
                      text: 'Ouch!\n\n',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => UrlHelper.openUrl(
                            'https://icons8.com/illustrations'),
                      style: GoogleFonts.oxygen(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: AppColors.orange,
                      ),
                    ),
                    const TextSpan(
                      text: 'Collections: ',
                    ),
                    TextSpan(
                      text: '3D Casual life',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => UrlHelper.openUrl(
                            'https://icons8.com/illustrations/style--3d-casual-life'),
                      style: GoogleFonts.oxygen(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: AppColors.orange,
                      ),
                    ),
                    const TextSpan(
                      text: '  & ',
                    ),
                    TextSpan(
                      text: '3D Business',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => UrlHelper.openUrl(
                            'https://icons8.com/illustrations/style--3d-business'),
                      style: GoogleFonts.oxygen(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: AppColors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
