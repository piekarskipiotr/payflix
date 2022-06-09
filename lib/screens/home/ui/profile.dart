import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0.0,
          expandedHeight: 200.0,
          backgroundColor: Colors.transparent,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              var top = constraints.biggest.height;

              return Container(
                decoration: BoxDecoration(
                  gradient:
                  top <= 56.0 ? AppTheme.appBarGradientExperimental : null,
                ),
                child: FlexibleSpaceBar(
                  expandedTitleScale: 2.44,
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: 13.0,
                  ),
                  title: Text(
                    getString(context).profile,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.oxygen(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.creamWhite,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
