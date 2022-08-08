import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/app_listener_bloc/app_listener.dart';
import 'package:payflix/app_listener_bloc/app_listener_cubit.dart';
import 'package:payflix/app_listener_bloc/app_listener_state.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_state.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_state_listener.dart';

class VerificationRoom extends StatelessWidget {
  const VerificationRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerRoomCubit, VerRoomState>(
          listener: (context, state) =>
              VerRoomStateListener.listenToState(context, state),
        ),
        BlocListener<AppListenerCubit, AppListenerState>(
          listener: (context, state) => AppListener.listenToState(
            context,
            state,
            getIt<JoiningGroupDialogCubit>(),
          ),
        ),
      ],
      child: WillPopScope(
        onWillPop: () => context.read<VerRoomCubit>().logOut(),
        child: Scaffold(
          body: SafeArea(
            top: true,
            bottom: true,
            child: Center(
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
                          padding:
                              const EdgeInsets.only(left: 25.0, right: 25.0),
                          child: Text(
                            getString(context).email_verification_room_title,
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
                          width: 242.0,
                          height: 242.0,
                          child: Lottie.asset(lottieEmailVerify, repeat: true),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: getString(context)
                                      .email_verification_room_secondary_part_1,
                                ),
                                TextSpan(
                                  text: getString(context).click_here,
                                  style: GoogleFonts.oxygen(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => context
                                        .read<VerRoomCubit>()
                                        .resendVerificationEmail(),
                                ),
                                TextSpan(
                                  text: getString(context)
                                      .email_verification_room_secondary_part_2,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    ListTile(
                      onTap: () => context.read<VerRoomCubit>().logOut(),
                      title: Text(
                        getString(context).log_out,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxygen(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: AppColors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
