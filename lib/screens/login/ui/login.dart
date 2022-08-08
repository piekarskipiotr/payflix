import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/app_listener_bloc/app_listener.dart';
import 'package:payflix/app_listener_bloc/app_listener_cubit.dart';
import 'package:payflix/app_listener_bloc/app_listener_state.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/validators/login_validation.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';
import 'package:payflix/screens/login/bloc/login_state_listener.dart';
import 'package:payflix/screens/login/ui/restart_password_dialog.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const Login({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginCubit, LoginState>(
          listener: (context, state) =>
              LoginStateListener.listenToState(context, state),
        ),
        BlocListener<AppListenerCubit, AppListenerState>(
          listener: (context, state) => AppListener.listenToState(
            context,
            state,
            getIt<JoiningGroupDialogCubit>(),
          ),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: true,
          bottom: true,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(
                    top: 48.0,
                    right: 15.0,
                  ),
                  child: Image.asset(
                    person2,
                    scale: 1.6,
                  ),
                ),
              ),
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  AppBarWithFixedTitle(
                    title: getString(context).login,
                    actions: null,
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25.0,
                        ),
                        BlurContainer(
                          body: Form(
                            key: formKey,
                            child: BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    TextFormField(
                                      validator: (emailID) =>
                                          LoginValidation.validateEmailIdField(
                                              context, emailID),
                                      onSaved: (emailID) => context
                                          .read<LoginCubit>()
                                          .saveEmailID(emailID),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      style: GoogleFonts.oxygen(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        prefixIcon: const Icon(
                                          Icons.alternate_email,
                                          size: 22.0,
                                          color: AppColors.creamWhite,
                                        ),
                                        hintText: getString(context).email_id,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      validator: (password) =>
                                          LoginValidation.validatePasswordField(
                                              context, password),
                                      onSaved: (password) => context
                                          .read<LoginCubit>()
                                          .savePassword(password),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      style: GoogleFonts.oxygen(),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(right: 10.0),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 22.0,
                                          color: AppColors.creamWhite,
                                        ),
                                        hintText: getString(context).password,
                                        suffixIcon: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: state is! LoggingIn
                                                  ? () {
                                                      formKey.currentState!
                                                          .save();
                                                      AppDialogController
                                                          .showBottomSheetDialog(
                                                        context,
                                                        BlocProvider.value(
                                                          value: context.read<
                                                              LoginCubit>(),
                                                          child:
                                                              RestartPasswordDialog(
                                                            formKey: GlobalKey<
                                                                FormState>(),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  : null,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 15.0,
                                                ),
                                                child: Text(
                                                  getString(context).forgot,
                                                  style: GoogleFonts.oxygen(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: AppColors.accent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25.0,
                                    ),
                                    PrimaryButton(
                                      text: getString(context).log_in,
                                      onClick: state is! LoggingIn
                                          ? () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                context
                                                    .read<LoginCubit>()
                                                    .authenticateUserByForm();
                                              }
                                            }
                                          : null,
                                      isLoading: state is LoggingIn,
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
                                            fontSize: 16.0,
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
                                    Material(
                                      color: AppColors.fieldBlack,
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(
                                        18.0,
                                      ),
                                      child: InkWell(
                                        onTap: state is! LoggingIn
                                            ? () => context
                                                .read<LoginCubit>()
                                                .authenticateUserByGoogleAccount()
                                            : null,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.fieldBlack
                                                .withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(
                                              18.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  googleIcon,
                                                  height: 22.0,
                                                  width: 22.0,
                                                ),
                                                const SizedBox(
                                                  width: 12.0,
                                                ),
                                                Text(
                                                  getString(context)
                                                      .continue_with_google,
                                                  maxLines: 1,
                                                  style: GoogleFonts.oxygen(
                                                    color: AppColors.creamWhite,
                                                    fontSize: 16.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Material(
                                      color: AppColors.fieldBlack,
                                      clipBehavior: Clip.antiAlias,
                                      borderRadius: BorderRadius.circular(
                                        18.0,
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.fieldBlack
                                                .withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(
                                              18.0,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(13.0),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  appleIcon,
                                                  height: 22.0,
                                                  width: 22.0,
                                                ),
                                                const SizedBox(
                                                  width: 12.0,
                                                ),
                                                Text(
                                                  getString(context)
                                                      .continue_with_apple,
                                                  maxLines: 1,
                                                  style: GoogleFonts.oxygen(
                                                    color: AppColors.creamWhite,
                                                    fontSize: 16.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                        const SizedBox(
                          height: 25.0,
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: getString(context).no_account_question,
                            style: GoogleFonts.oxygen(
                              color: AppColors.creamWhite,
                              fontSize: 16.0,
                            ),
                            children: <TextSpan>[
                              const TextSpan(text: '  '),
                              TextSpan(
                                text: getString(context).sign_up,
                                style: GoogleFonts.oxygen(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accent,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.signUp,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
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
