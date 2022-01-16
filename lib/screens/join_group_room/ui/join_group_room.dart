import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/app_dialog_helper.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/join_group_room/bloc/join_group_room_bloc.dart';
import 'package:payflix/screens/join_group_room/bloc/join_group_room_state.dart';
import 'package:payflix/screens/join_group_room/ui/where_to_get_group_key_dialog.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:payflix/widgets/long_button.dart';
import 'package:payflix/widgets/static_spacer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
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
                            opacity: top < 111 || top > 115 ? 1.0 : 0.0,
                            child: top < 113
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
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              staticSpacer(),
                              Image.asset(
                                wavingMan,
                                width: 192.0,
                                height: 192.0,
                              ),
                              staticSpacer(),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30.0),
                                child: Text(
                                  getString(context)
                                      .welcome_to_payflix_subtitle,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          staticSpacer(),
                          staticSpacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Form(
                              key: formKey,
                              child: PinCodeTextField(
                                length: 4,
                                animationType: AnimationType.none,
                                cursorColor: AppColors.gray,
                                validator: (value) => value?.length != 4
                                    ? getString(context).fill_all_fields
                                    : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                errorTextSpace: 25.0,
                                pinTheme: PinTheme(
                                  activeColor: AppColors.gray,
                                  selectedColor: AppColors.gray,
                                  inactiveColor: AppColors.gray,
                                  activeFillColor: AppColors.gray,
                                  selectedFillColor: AppColors.gray,
                                  inactiveFillColor: AppColors.gray,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(14),
                                  fieldHeight: 75,
                                  fieldWidth: 60,
                                ),
                                keyboardType: TextInputType.number,
                                boxShadows: [
                                  BoxShadow(
                                    color: AppColors.lightGray.withOpacity(0.8),
                                  )
                                ],
                                onCompleted: (code) => context
                                    .read<JoinGroupRoomBloc>()
                                    .joinGroup(code),
                                onChanged: (_) {},
                                appContext: context,
                              ),
                            ),
                          ),
                          staticSpacer(),
                          BlocBuilder<JoinGroupRoomBloc, JoinGroupRoomState>(
                            builder: (context, state) {
                              return LongButton(
                                  text: getString(context).join_the_group,
                                  isLoading: state is JoiningTheGroup,
                                  onClick: () {
                                    if (formKey.currentState!.validate()) {
                                      context
                                          .read<JoinGroupRoomBloc>()
                                          .joinGroup(null);
                                    }
                                  });
                            },
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    32.0,
                                  ),
                                  topLeft: Radius.circular(
                                    32.0,
                                  ),
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (builder) =>
                                  const WhereToGetGroupKeyDialog(),
                            ),
                            child: Text(
                              '${getString(context).where_key}?',
                              style: const TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
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
                                        context, AppRoutes.createGroup),
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
