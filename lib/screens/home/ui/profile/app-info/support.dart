import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/url_helper.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          getString(context).support,
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
                standingMan,
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
                getString(context).support_title,
                style: GoogleFonts.oxygen(
                  fontSize: 22.0,
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
                getString(context).support_title_2,
                style: GoogleFonts.oxygen(
                  fontSize: 18.0,
                  color: AppColors.creamWhite,
                ),
              ),
            ),
            const SizedBox(
              height: 64.0,
            ),
            ListTile(
              onTap: () => UrlHelper.openUrl('https://twitter.com/PayflixApp'),
              contentPadding: const EdgeInsets.only(left: 28.0),
              tileColor: const Color(0xFF1DA1F2),
              minLeadingWidth: 16.0,
              leading: SvgPicture.asset(
                twitterIcon,
                color: Colors.white,
                height: 24.0,
                width: 24.0,
                semanticsLabel: 'Twitter icon',
              ),
              title: Text(
                getString(context).open_twitter,
                style: GoogleFonts.oxygen(
                  fontSize: 16.0,
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
                getString(context).support_subtitle,
                style: GoogleFonts.oxygen(
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                  color: AppColors.lighterGray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
