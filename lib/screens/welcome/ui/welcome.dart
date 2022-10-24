import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/app_listener_bloc/app_listener.dart';
import 'package:payflix/app_listener_bloc/app_listener_cubit.dart';
import 'package:payflix/app_listener_bloc/app_listener_state.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/welcome/bloc/welcome_cubit.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _controller = PageController();
  var _currentPage = 0;

  @override
  void initState() {
    context.read<WelcomeCubit>().checkIfAlreadySeen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppListenerCubit, AppListenerState>(
      listener: (context, state) => AppListener.listenToState(
        context,
        state,
        getIt<JoiningGroupDialogCubit>(),
      ),
      child: BlocBuilder<WelcomeCubit, WelcomeState>(
        builder: (context, state) {
          if (state is CheckingWelcomeState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              top: true,
              bottom: true,
              child: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (index) => setState(
                      () => _currentPage = index,
                    ),
                    children: [
                      OnboardScreen(
                        title: getString(context).onboard_title_1,
                        secondary: getString(context).onboard_subtitle_1,
                        asset: sittingWomen,
                      ),
                      OnboardScreen(
                        title: getString(context).onboard_title_2,
                        secondary: getString(context).onboard_subtitle_2,
                        asset: holdingPhone,
                      ),
                      OnboardScreen(
                        title: getString(context).onboard_title_3,
                        secondary: getString(context).onboard_subtitle_3,
                        asset: groupOfWomen,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ...List.generate(
                              3,
                              (index) => DotIndicator(
                                isActive: index == _currentPage,
                              ),
                            ),
                          ],
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: 120.0,
                            child: PrimaryButton(
                              text: _currentPage != 2
                                  ? getString(context).next
                                  : getString(context).close,
                              onClick: () => _currentPage != 2
                                  ? _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.ease,
                                    )
                                  : Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      AppRoutes.home,
                                      (route) => false,
                                    ),
                              isLoading: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class OnboardScreen extends StatelessWidget {
  final String title;
  final String secondary;
  final String asset;

  const OnboardScreen({
    Key? key,
    required this.title,
    required this.secondary,
    required this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 92.0,
              ),
              Image.asset(
                asset,
                width: 256.0,
                height: 256.0,
              ),
              const SizedBox(
                height: 74.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oxygen(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.creamWhite,
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                ),
                child: Text(
                  secondary,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oxygen(
                    color: AppColors.creamWhite,
                    fontSize: 14.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4.0,
        right: 4.0,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 8,
        width: 8,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.creamWhite
              : AppColors.creamWhite.withOpacity(0.5),
          borderRadius: const BorderRadius.all(
            Radius.circular(24.0),
          ),
        ),
      ),
    );
  }
}
