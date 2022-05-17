import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/sign_up_validation.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/signup/bloc/signup_cubit.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';
import 'package:payflix/screens/signup/bloc/signup_state_listener.dart';
import 'package:payflix/screens/picking_avatar_dialog/ui/picking_avatar_dialog.dart';
import 'package:payflix/widgets/blur_container.dart';
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
    return BlocListener<SignUpCubit, SignupState>(
      listener: (context, state) =>
          getIt<SignupStateListener>().listenToState(context, state),
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
                  SliverAppBar(
                    pinned: true,
                    elevation: 0.0,
                    expandedHeight: 200.0,
                    backgroundColor: Colors.transparent,
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: context
                          .watch<SignUpCubit>()
                          .showRegularTitle()
                          ? 1.0
                          : 0.0,
                      child: Text(
                        getString(context).signup,
                        maxLines: 1,
                        style: GoogleFonts.oxygen(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.creamWhite,
                        ),
                      ),
                    ),
                    flexibleSpace: LayoutBuilder(
                      builder: (context, constraints) {
                        var top = constraints.biggest.height;
                        context.read<SignUpCubit>().handleTitle(top);

                        return Container(
                          decoration: BoxDecoration(
                            gradient: top <= 56.0 ? AppTheme.appBarGradientExperimental : null,
                          ),
                          child: FlexibleSpaceBar(
                            centerTitle: false,
                            titlePadding: const EdgeInsets.only(
                              left: 15.0,
                              right: 15.0,
                              bottom: 13.0,
                            ),
                            title: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: top > minTitleTopValue + 10.0 ? 1.0 : 0.0,
                              child: Text(
                                getString(context).signup,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.oxygen(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.creamWhite,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
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
                            child: BlocBuilder<SignUpCubit, SignupState>(
                              builder: (context, state) {
                                var avatar =
                                    context.watch<SignUpCubit>().avatar;
                                var color = context.watch<SignUpCubit>().color;

                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 64.0,
                                          height: 64.0,
                                          child: Material(
                                            elevation: 0,
                                            clipBehavior: Clip.hardEdge,
                                            type: MaterialType.circle,
                                            color:
                                                color ?? AppColors.creamWhite,
                                            child: Stack(
                                              children: [
                                                if (avatar != null) ...[
                                                  Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 4.0,
                                                      ),
                                                      Expanded(
                                                        child: Center(
                                                          child: Image.asset(
                                                            avatar,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                                Positioned.fill(
                                                  child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                        child: avatar == null
                                                            ? Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    getString(
                                                                            context)
                                                                        .tap_to_choose,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts
                                                                        .oxygen(
                                                                      fontSize:
                                                                          10.0,
                                                                      color: AppColors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            : null,
                                                        onTap: () {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          AppDialogController
                                                              .showBottomSheetDialog(
                                                            context,
                                                            BlocProvider.value(
                                                              value: context
                                                                  .read<
                                                                      SignUpCubit>()
                                                                  .getDialogCubit(),
                                                              child:
                                                                  const PickingAvatarDialog(),
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 6.0,
                                            ),
                                            child: Text(
                                              getString(context)
                                                  .picking_avatar_desc,
                                              style: GoogleFonts.oxygen(
                                                fontSize: 12.0,
                                                color: AppColors.creamWhite,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 15.0,
                                    ),
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
                                      style: GoogleFonts.oxygen(),
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
                                      style: GoogleFonts.oxygen(),
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
                                          onChanged: (_) {
                                            FocusScope.of(context).unfocus();
                                            context
                                                .read<SignUpCubit>()
                                                .changeTCPPStatus();
                                          },
                                        ),
                                        Expanded(
                                          child: RichText(
                                            textAlign: TextAlign.left,
                                            text: TextSpan(
                                              text: getString(context)
                                                  .sign_up_checkbox_text_part_1,
                                              style: GoogleFonts.oxygen(
                                                  fontSize: 14.0,
                                                  color: AppColors.creamWhite,
                                                  height: 1.2),
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: getString(context)
                                                      .terms_and_conditions,
                                                  style: GoogleFonts.oxygen(
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
                                                  style: GoogleFonts.oxygen(
                                                    color: AppColors.creamWhite,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: getString(context)
                                                      .privacy_policy,
                                                  style: GoogleFonts.oxygen(
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
                                                  .isAllFilledUp() &&
                                              state is! SigningUp
                                          ? () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                FocusScope.of(context)
                                                    .unfocus();
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
