import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/app_dialog_helper.dart';
import 'package:payflix/common/helpers/opacity_helper.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/join_group_room/bloc/join_group_room_bloc.dart';
import 'package:payflix/screens/join_group_room/bloc/join_group_room_state.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:payflix/widgets/long_outlined_button.dart';
import 'package:payflix/widgets/static_bigger_spacer.dart';
import 'package:payflix/widgets/static_spacer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinGroupRoom extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const JoinGroupRoom({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<JoinGroupRoomBloc, JoinGroupRoomState>(
        listener: (context, state) {
          if (state is JoiningTheGroupFailed) {
            AppDialogHelper.showFullScreenDialog(
              context,
              FullScreenDialog(
                headerText: getString(context).join_the_group_failed,
                secondaryText:
                    getString(context).join_the_group_failed_explanation,
                statusIcon: Icons.sentiment_dissatisfied,
                statusIconColor: Colors.white,
                statusIconBackgroundColor: Colors.red,
                buttonIcon: Icons.close,
                buttonText: getString(context).close_dialog,
                buttonOnClick: () => Navigator.pop(context),
              ),
            );
          }
        },
        child: WillPopScope(
          onWillPop: () =>
              context.read<JoinGroupRoomBloc>().popAndLogout(context),
          child: Scaffold(
            body: SafeArea(
              top: true,
              bottom: true,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    elevation: 0.0,
                    pinned: true,
                    expandedHeight: 150.0,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: IconButton(
                        onPressed: () => context
                            .read<JoinGroupRoomBloc>()
                            .popAndLogout(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 22.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        var top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: const EdgeInsets.only(
                            left: 50.0,
                            right: 50.0,
                            bottom: 13.0,
                          ),
                          title: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: OpacityHelper.calculateHeaderOpacity(
                                top, 81.0, 91.0),
                            child: top < 86
                                ? Text(
                                    getString(context)
                                        .welcome_to_payflix
                                        .replaceAll('\n', ' '),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  )
                                : Text(
                                    getString(context).welcome_to_payflix,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 28.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Column(
                        children: [
                          staticSpacer(),
                          Image.asset(
                            wavingMan,
                            width: 192.0,
                            height: 192.0,
                          ),
                          staticBiggerSpacer(),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  '${getString(context).welcome_to_payflix_part_1}, ',
                              style: const TextStyle(
                                color: AppColors.gray,
                                fontSize: 17.0,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: FirebaseAuth
                                          .instance.currentUser?.displayName ??
                                      'username',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: getString(context)
                                      .welcome_to_payflix_part_2,
                                  style: const TextStyle(
                                    color: AppColors.gray,
                                  ),
                                ),
                                TextSpan(
                                  text: getString(context).create_new_group,
                                  style: const TextStyle(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: getString(context)
                                      .welcome_to_payflix_part_3,
                                  style: const TextStyle(
                                    color: AppColors.gray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          staticBiggerSpacer(),
                          Text(
                            getString(context).how_to_join,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          staticBiggerSpacer(),
                          Text(
                            getString(context).how_to_join_desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.gray,
                              fontSize: 17.0,
                            ),
                          ),
                          staticBiggerSpacer(),
                          Container(
                            width: 92.0,
                            height: 92.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.0),
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.link,
                              color: Colors.white,
                              size: 56.0,
                            ),
                          ),
                          staticSpacer(),
                          Text(
                            getString(context).via_link,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22.0),
                          ),
                          staticSpacer(),
                          Text(
                            getString(context).via_link_desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.gray,
                              fontSize: 17.0,
                            ),
                          ),
                          staticBiggerSpacer(),
                          Container(
                            width: 92.0,
                            height: 92.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.0),
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.qr_code,
                              color: Colors.white,
                              size: 56.0,
                            ),
                          ),
                          staticSpacer(),
                          Text(
                            getString(context).scan_qr_code,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22.0),
                          ),
                          staticSpacer(),
                          Text(
                            getString(context).scan_qr_code_desc,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.gray,
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.shortestSide / 1.2,
                            child: Lottie.asset(qrScan),
                          ),
                          LongOutlinedButton(
                            text: getString(context).scan_now,
                            onClick: () {},
                            isLoading: false,
                          ),
                          staticSpacer(),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.lightGray,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          RichText(
                            text: TextSpan(
                              text:
                                  '${getString(context).are_your_group_owner} ',
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: getString(context).create,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, AppRoutes.groupSettings),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          staticSpacer(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
