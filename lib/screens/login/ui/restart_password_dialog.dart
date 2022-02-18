import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/validators/login_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/login/bloc/login_cubit.dart';
import 'package:payflix/screens/login/bloc/login_state.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/widgets/secondary_button.dart';

class RestartPasswordDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const RestartPasswordDialog({Key? key, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5.0,
                width: 100.0,
                decoration: BoxDecoration(
                  color: AppColors.lighterGray,
                  borderRadius: BorderRadius.circular(28.0),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Text(
                getString(context).restart_password_header_text,
                style: GoogleFonts.nunito(
                  color: AppColors.creamWhite,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                initialValue: context.read<LoginCubit>().getEmailID(),
                validator: (emailID) =>
                    LoginValidation.validateEmailIdField(context, emailID),
                onSaved: (emailID) =>
                    context.read<LoginCubit>().saveEmailID(emailID),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                maxLines: 1,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.nunito(),
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
                height: 80.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      text: getString(context).cancel,
                      isLoading: false,
                      onClick: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(
                    width: 25.0,
                  ),
                  Expanded(
                    child: BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return PrimaryButton(
                          text: getString(context).restart,
                          onClick: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              context.read<LoginCubit>().restartPassword();
                            }
                          },
                          isLoading: state is SendingPasswordResetEmail,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
