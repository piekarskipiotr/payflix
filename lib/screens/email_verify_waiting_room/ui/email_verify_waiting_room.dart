import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/email_verify_waiting_room/bloc/email_verify_waiting_room_bloc.dart';
import 'package:payflix/screens/email_verify_waiting_room/bloc/email_verify_waiting_room_state.dart';
import 'package:payflix/widgets/result_snack_bar.dart';

class EmailVerifyWaitingRoom extends StatelessWidget {
  const EmailVerifyWaitingRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () =>
          context.read<EmailVerifyWaitingRoomBloc>().popAndLogout(context),
      child:
          BlocListener<EmailVerifyWaitingRoomBloc, EmailVerifyWaitingRoomState>(
        listener: (context, state) {
          if (state is SendingVerificationEmail) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                      ),
                      height: 24.0,
                      width: 24.0,
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(getString(context).sending),
                  ],
                ),
                backgroundColor: AppColors.gray,
                duration: const Duration(days: 365),
                dismissDirection: DismissDirection.none,
              ),
            );
          } else if (state is SendingVerificationEmailSucceeded) {
            context.read<EmailVerifyWaitingRoomBloc>().clearSnackBars(context);
            ScaffoldMessenger.of(context).showSnackBar(
              resultSnackBar(
                context,
                Icons.done,
                AppColors.green,
                getString(context).sending_email_succeeded,
                AppColors.green,
              ),
            );
          } else if (state is SendingVerificationEmailFailed) {
            context.read<EmailVerifyWaitingRoomBloc>().clearSnackBars(context);
            ScaffoldMessenger.of(context).showSnackBar(
              resultSnackBar(
                context,
                Icons.priority_high,
                Colors.red,
                getString(context).sending_email_failed,
                Colors.red,
              ),
            );
          } else if (state is EmailVerifiedMovingToJoinGroupRoom) {
            context.read<EmailVerifyWaitingRoomBloc>().clearSnackBars(context);

            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.joinGroupRoom, (route) => false);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            leading: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: IconButton(
                onPressed: () => context
                    .read<EmailVerifyWaitingRoomBloc>()
                    .popAndLogout(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 22.0,
                ),
              ),
            ),
          ),
          body: SafeArea(
            top: true,
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        getString(context).verify_email,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      SizedBox(
                        width: 192.0,
                        height: 192.0,
                        child: Lottie.asset(emailVerify),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: getString(context).email_not_verified,
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: getString(context)
                                .email_not_verified_verify,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context
                                  .read<EmailVerifyWaitingRoomBloc>()
                                  .resendVerificationEmail(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
