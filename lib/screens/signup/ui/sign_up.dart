import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/sign_up_validation.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/signup/bloc/signup_cubit.dart';
import 'package:payflix/screens/signup/bloc/signup_state.dart';
import 'package:payflix/screens/signup/bloc/signup_state_listener.dart';
import 'package:payflix/screens/picking_avatar_dialog/ui/picking_avatar_dialog.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_cubit.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/ui/app_bar_with_moved_title.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
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
                  BlocProvider.value(
                    value: getIt<AppBarCubit>(),
                    child: AppBarWithMovedTitle(
                      title: getString(context).signup,
                      actions: null,
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
                                var avatar = context
                                    .read<SignUpCubit>()
                                    .getSelectedAvatar();

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
                                            color: avatar?.background ??
                                                AppColors.creamWhite,
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
                                                          child: AppCachedNetworkImage(
                                                            url: avatar.url,
                                                            placeholder: AppPlaceholder.avatar,
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
                                                                  style:
                                                                      GoogleFonts
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
                                                          context: context,
                                                          dialog: BlocProvider.value(
                                                            value: context
                                                                .read<
                                                                    SignUpCubit>()
                                                                .getDialogCubit(),
                                                            child:
                                                                const PickingAvatarDialog(),
                                                          ),
                                                        );
                                                      },
                                                    ),
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
                                      obscureText: context.watch<SignUpCubit>().isPasswordVisible(),
                                      style: GoogleFonts.oxygen(),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.zero,
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 22.0,
                                          color: AppColors.creamWhite,
                                        ),
                                        suffixIcon: Material(
                                          color: Colors.transparent,
                                          child: IconButton(
                                            onPressed: () => context
                                                .read<SignUpCubit>()
                                                .changePasswordVisibility(),
                                            splashRadius: 20.0,
                                            icon: Icon(
                                              context
                                                  .watch<
                                                  SignUpCubit>()
                                                  .isPasswordVisible()
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              size: 22.0,
                                              color: AppColors.creamWhite,
                                            ),
                                          ),
                                        ),
                                        hintText: getString(context).password,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25.0,
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
