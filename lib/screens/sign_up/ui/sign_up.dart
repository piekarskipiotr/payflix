import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/app_dialog_helper.dart';
import 'package:payflix/common/helpers/sign_up_helper.dart';
import 'package:payflix/common/validators/sign_up_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/sign_up/bloc/sign_up_cubit.dart';
import 'package:payflix/screens/sign_up/bloc/sign_up_state.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const SignUp({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state is SigningUpFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackBar(
              context,
              SignUpHelper.tryConvertErrorCodeToMessage(
                context,
                state.error,
              ),
            ),
          );
        } else if (state is SigningUpSucceeded) {
          AppDialogHelper.showFullScreenDialog(
            context,
            FullScreenDialog(
              title: getString(context).sign_up_succeeded_title,
              secondary:getString(context).sign_up_succeeded_secondary,
              animation: lottieSuccess,
              onClick: () => Navigator.pop(context),
            ),
          );
        }
      },
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
                    top: 20.0,
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
                  SliverAppBar(
                    elevation: 0.0,
                    expandedHeight: 200.0,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: const EdgeInsets.only(
                        left: 25.0,
                        right: 25.0,
                        bottom: 13.0,
                      ),
                      title: Text(
                        getString(context).sign_up_title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.creamWhite,
                        ),
                      ),
                    ),
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
                            child: BlocBuilder<SignUpCubit, SignUpState>(
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    TextFormField(
                                      onSaved: (profileName) => context
                                          .read<SignUpCubit>()
                                          .saveProfileName(
                                            profileName,
                                          ),
                                      validator: (value) =>
                                          SignUpValidation.validateProfileName(
                                        context,
                                        value,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        prefixIcon: const Icon(
                                          Icons.person,
                                          size: 22.0,
                                          color: AppColors.creamWhite,
                                        ),
                                        hintText:
                                            getString(context).profile_name,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    TextFormField(
                                      onSaved: (emailID) => context
                                          .read<SignUpCubit>()
                                          .saveEmailID(
                                            emailID,
                                          ),
                                      validator: (value) =>
                                          SignUpValidation.validateEmailIdField(
                                        context,
                                        value,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.next,
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
                                      onSaved: (password) => context
                                          .read<SignUpCubit>()
                                          .savePassword(
                                            password,
                                          ),
                                      validator: (value) => SignUpValidation
                                          .validatePasswordField(
                                        context,
                                        value,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLines: 1,
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 22.0,
                                          color: AppColors.creamWhite,
                                        ),
                                        hintText: getString(context).password,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Checkbox(
                                          value: context
                                              .watch<SignUpCubit>()
                                              .isTCPPAccepted(),
                                          onChanged: (_) => context
                                              .read<SignUpCubit>()
                                              .changeTCPPStatus(),
                                        ),
                                        Expanded(
                                          child: RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              text: getString(context)
                                                  .sign_up_checkbox_text_part_1,
                                              style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: AppColors.creamWhite,
                                                  height: 1.2),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: getString(context)
                                                      .terms_and_conditions,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.accent,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () => {},
                                                ),
                                                TextSpan(
                                                  text: getString(context)
                                                      .sign_up_checkbox_text_part_2,
                                                  style: const TextStyle(
                                                    color: AppColors.creamWhite,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: getString(context)
                                                      .privacy_policy,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.accent,
                                                  ),
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () => {},
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 35.0,
                                    ),
                                    PrimaryButton(
                                      text: getString(context).sign_up,
                                      onClick: context
                                              .watch<SignUpCubit>()
                                              .isTCPPAccepted()
                                          ? () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                context
                                                    .read<SignUpCubit>()
                                                    .signUp();
                                              }
                                            }
                                          : null,
                                      isLoading: state is SigningUp,
                                    ),
                                  ],
                                );
                              },
                            ),
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
