import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_cubit.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_listener.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

class LaunchingScreen extends StatelessWidget {
  const LaunchingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LaunchingScreenCubit, LaunchingScreenState>(
      listener: (context, state) => LaunchingScreenListener.listenToState(
        context,
        state,
        context.read<LaunchingScreenCubit>().getJoiningGroupDialogCubit(),
      ),
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 5.0),
                Text(
                  getString(context).initializing_app,
                  style: GoogleFonts.oxygen(
                    color: AppColors.creamWhite,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
