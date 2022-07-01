import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/welcome/bloc/welcome_cubit.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state_listener.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Welcome extends StatelessWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeCubit, WelcomeState>(
      listener: (context, state) =>
          WelcomeStateListener.listenToState(context, state),
      child: Scaffold(
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
                  AppBarWithFixedTitle(
                    title: getString(context).welcome,
                    actions: null,
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: AppTheme.welcomeGradientExperimental,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
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
                                          arguments: [true, null],
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
                                        onClick: () => Navigator.pushNamed(
                                          context,
                                          AppRoutes.qrScanner,
                                        ),
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
                                    const SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(
                                      getString(context).or,
                                      style: GoogleFonts.oxygen(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12.0,
                                    ),
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
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
