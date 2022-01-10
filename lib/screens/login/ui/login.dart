import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/app_dialog_helper.dart';
import 'package:payflix/common/helpers/login_helper.dart';
import 'package:payflix/common/validators/login_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/login/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:payflix/widgets/long_button.dart';
import 'package:payflix/widgets/static_spacer.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const Login({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              children: [
                staticSpacer(),
                Column(
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    Image.asset(welcomeHumanImage),
                    const SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
                staticSpacer(),
                BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoggingInSucceeded) {
                      formKey.currentState?.reset();
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.playground, (route) => false);
                    } else if (state is LoggingInFailed) {
                      AppDialogHelper.showFullScreenDialog(
                        context,
                        FullScreenDialog(
                          headerText: getString(context).logging_in_failed,
                          secondaryText:
                              LoginHelper.tryConvertErrorCodeToMessage(
                            context,
                            state.errorCode,
                          ),
                          statusIcon: Icons.sentiment_dissatisfied,
                          statusIconColor: Colors.white,
                          statusIconBackgroundColor: Colors.red,
                          buttonIcon: Icons.close,
                          buttonText: getString(context).close_dialog,
                          buttonOnClick: () => Navigator.pop(context),
                        ),
                      );
                    } else if (state is NavigateToWaitingRoom) {
                      formKey.currentState?.reset();
                      Navigator.pushNamed(
                          context, AppRoutes.emailVerifyWaitingRoom);
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getString(context).login,
                              style: const TextStyle(
                                  fontSize: 48.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            onSaved: (value) =>
                                context.read<LoginBloc>().setEmailId(value),
                            validator: (value) =>
                                LoginValidation.validateEmailIdField(
                                    context, value),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              prefixIcon: const Icon(
                                Icons.email,
                                color: AppColors.gray,
                              ),
                              hintText: getString(context).email_id,
                              hintStyle: const TextStyle(color: AppColors.gray),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          TextFormField(
                            onSaved: (value) =>
                                context.read<LoginBloc>().setPassword(value),
                            validator: (value) =>
                                LoginValidation.validatePasswordField(
                                    context, value),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLines: 1,
                            textAlignVertical: TextAlignVertical.center,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.gray,
                              ),
                              hintText: getString(context).password,
                              hintStyle: const TextStyle(color: AppColors.gray),
                              suffixIcon: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => context
                                        .read<LoginBloc>()
                                        .restartPassword(),
                                    child: Text(
                                      getString(context).forgot,
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          LongButton(
                            text: getString(context).login,
                            onClick: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                FocusScope.of(context).unfocus();
                                context
                                    .read<LoginBloc>()
                                    .authenticateUserByForm();
                              }
                            },
                            isLoading: state is LoggingIn,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          RichText(
                            text: TextSpan(
                              text: '${getString(context).no_account_text} ',
                              style: const TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  text: getString(context).register,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.pushNamed(
                                          context, AppRoutes.registration);
                                    },
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ],
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
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              getString(context).login_register_with,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 30.0,
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    context
                                        .read<LoginBloc>()
                                        .authenticateUserByGoogleAccount();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 14.0,
                                      right: 10.0,
                                      bottom: 14.0,
                                    ),
                                    child: SvgPicture.asset(
                                      googleIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    context
                                        .read<LoginBloc>()
                                        .authenticateUserByAppleAccount();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      top: 9.0,
                                      right: 5.0,
                                      bottom: 9.0,
                                    ),
                                    child: SvgPicture.asset(
                                      appleIcon,
                                      width: 34,
                                      height: 34,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30.0,
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
                staticSpacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
