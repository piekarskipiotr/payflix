import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/validators/change_password_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/ui/profile/bloc/change_password_dialog_state_listener.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'bloc/change_password_dialog_cubit.dart';
import 'bloc/change_password_dialog_state.dart';

class ChangePasswordDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const ChangePasswordDialog({Key? key, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordDialogCubit, ChangePasswordDialogState>(
      listener: (context, state) =>
          ChangePasswordDialogStateListener.listenToState(context, state),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            getString(context).change_password,
            style: GoogleFonts.oxygen(
              fontSize: 18.0,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25.0, right: 25.0),
            child: BlocBuilder<ChangePasswordDialogCubit,
                ChangePasswordDialogState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      onChanged: (password) => context
                          .read<ChangePasswordDialogCubit>()
                          .setPreviousPassword(password),
                      validator: (password) =>
                          ChangePasswordValidation.validatePasswordField(
                        context,
                        password,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      readOnly: state is ChangingUserPassword,
                      obscureText: context
                          .watch<ChangePasswordDialogCubit>()
                          .isPreviousPasswordVisible(),
                      style: GoogleFonts.oxygen(),
                      decoration: InputDecoration(
                        hintText: getString(context).previous_password,
                        suffixIcon: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () => context
                                .read<ChangePasswordDialogCubit>()
                                .changePreviousPasswordVisibility(),
                            splashRadius: 20.0,
                            icon: Icon(
                              context
                                      .watch<ChangePasswordDialogCubit>()
                                      .isPreviousPasswordVisible()
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 22.0,
                              color: AppColors.creamWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 17.0,
                    ),
                    TextFormField(
                      onChanged: (password) => context
                          .read<ChangePasswordDialogCubit>()
                          .setNewPassword(password),
                      validator: (password) =>
                          ChangePasswordValidation.validateNewPasswordField(
                        context,
                        context
                            .read<ChangePasswordDialogCubit>()
                            .getPreviousPassword(),
                        password,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      readOnly: state is ChangingUserPassword,
                      obscureText: context
                          .watch<ChangePasswordDialogCubit>()
                          .isNewPasswordVisible(),
                      style: GoogleFonts.oxygen(),
                      decoration: InputDecoration(
                        hintText: getString(context).new_password,
                        suffixIcon: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () => context
                                .read<ChangePasswordDialogCubit>()
                                .changeNewPasswordVisibility(),
                            splashRadius: 20.0,
                            icon: Icon(
                              context
                                      .watch<ChangePasswordDialogCubit>()
                                      .isNewPasswordVisible()
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 22.0,
                              color: AppColors.creamWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 17.0,
                    ),
                    TextFormField(
                      onChanged: (password) => context
                          .read<ChangePasswordDialogCubit>()
                          .setConfirmPassword(password),
                      validator: (password) =>
                          ChangePasswordValidation.validateConfirmPasswordField(
                        context,
                        context
                            .read<ChangePasswordDialogCubit>()
                            .getNewPassword(),
                        password,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      readOnly: state is ChangingUserPassword,
                      obscureText: context
                          .watch<ChangePasswordDialogCubit>()
                          .isConfirmPasswordVisible(),
                      style: GoogleFonts.oxygen(),
                      decoration: InputDecoration(
                        hintText: getString(context).confirm_password,
                        suffixIcon: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            onPressed: () => context
                                .read<ChangePasswordDialogCubit>()
                                .changeConfirmPasswordVisibility(),
                            splashRadius: 20.0,
                            icon: Icon(
                              context
                                      .watch<ChangePasswordDialogCubit>()
                                      .isConfirmPasswordVisible()
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 22.0,
                              color: AppColors.creamWhite,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 27.0,
                    ),
                    PrimaryButton(
                      text: getString(context).change,
                      onClick: state is ChangingUserPassword
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                context
                                    .read<ChangePasswordDialogCubit>()
                                    .changePassword();
                              }
                            },
                      isLoading: state is ChangingUserPassword,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
