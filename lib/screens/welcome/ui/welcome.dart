import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Positioned(
              right: -15.0,
              child: Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.only(
                  top: 20.0,
                ),
                child: Image.asset(
                  happyPerson,
                  scale: 2.0,
                ),
              ),
            ),
            CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0.0,
                  expandedHeight: 250.0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      bottom: 13.0,
                    ),
                    title: Text(
                      getString(context).welcome,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oxygen(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.creamWhite,
                      ),
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15.0,
                      right: 15.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.welcomeGradientExperimental,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 125.0,
                              ),
                              Text(
                                getString(context).welcome_info_text,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oxygen(
                                  color: AppColors.creamWhite,
                                  fontSize: 18.0,
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: SecondaryButton(
                                      text: getString(context).create,
                                      onClick: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.groupSettings,
                                        arguments: true,
                                      ),
                                      isLoading: false,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 25.0,
                                  ),
                                  Expanded(
                                    child: PrimaryButton(
                                      text: getString(context).scan,
                                      onClick: () => {},
                                      isLoading: false,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Row(
                                children: [
                                  const Expanded(
                                    child: Divider(
                                      height: 1.0,
                                      color: AppColors.gray,
                                      thickness: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0,),
                                  Text(
                                    getString(context).or,
                                    style: GoogleFonts.oxygen(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 12.0,),
                                  const Expanded(
                                    child: Divider(
                                      height: 1.0,
                                      color: AppColors.gray,
                                      thickness: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Text(
                                getString(context).welcome_bottom_text,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oxygen(
                                  color: AppColors.creamWhite,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
