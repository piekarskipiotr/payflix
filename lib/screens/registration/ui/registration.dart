import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payflix/common/helpers/app_dialog_helper.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/registration_helper.dart';
import 'package:payflix/common/validators/registration_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/registration/bloc/registration_bloc.dart';
import 'package:payflix/screens/registration/bloc/registration_state.dart';
import 'package:payflix/screens/registration/ui/terms_and_conditions_dialog.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:payflix/widgets/long_button.dart';
import 'package:payflix/widgets/static_spacer.dart';

class Registration extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const Registration({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            SingleChildScrollView(
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
                        Image.asset(womenWithLaptop),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                    staticSpacer(),
                    BlocConsumer<RegistrationBloc, RegistrationState>(
                      listener: (context, state) {
                        if (state is CreatingUserAccountSucceeded) {
                          AppDialogHelper.showFullScreenDialog(
                            context,
                            FullScreenDialog(
                              headerText:
                                  getString(context).registration_succeeded,
                              secondaryText:
                                  getString(context).please_confirm_email,
                              statusIcon: Icons.done,
                              statusIconColor: Colors.white,
                              statusIconBackgroundColor: AppColors.green,
                              buttonIcon: Icons.close,
                              buttonText: getString(context).close_dialog,
                              buttonOnClick: () =>
                                  Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              ),
                            ),
                          );
                        } else if (state is CreatingUserAccountFailed) {
                          AppDialogHelper.showFullScreenDialog(
                            context,
                            FullScreenDialog(
                              headerText:
                                  getString(context).registration_failed,
                              secondaryText: RegistrationHelper
                                  .tryConvertErrorCodeToMessage(
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
                                  getString(context).registration,
                                  style: const TextStyle(
                                      fontSize: 48.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                enabled: state is! CreatingUserAccount,
                                onSaved: (value) => context
                                    .read<RegistrationBloc>()
                                    .setProfileName(value),
                                validator: (value) =>
                                    RegistrationValidation.validateProfileName(
                                        context, value),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: AppColors.gray,
                                  ),
                                  hintText: getString(context).profile_name,
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                enabled: state is! CreatingUserAccount,
                                onSaved: (value) => context
                                    .read<RegistrationBloc>()
                                    .setEmailId(value),
                                validator: (value) =>
                                    RegistrationValidation.validateEmailIdField(
                                  context,
                                  value,
                                ),
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
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                enabled: state is! CreatingUserAccount,
                                onChanged: (value) => context
                                    .read<RegistrationBloc>()
                                    .setPassword(value),
                                validator: (value) => RegistrationValidation
                                    .validatePasswordField(
                                  context,
                                  value,
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                obscureText: true,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: AppColors.gray,
                                  ),
                                  hintText: getString(context).password,
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                enabled: state is! CreatingUserAccount,
                                validator: (value) => RegistrationValidation
                                    .validateConfirmPasswordField(
                                        context,
                                        value,
                                        context
                                            .read<RegistrationBloc>()
                                            .getPassword()),
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
                                  hintText: getString(context).confirm_password,
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              CheckboxListTile(
                                value: context
                                    .watch<RegistrationBloc>()
                                    .isTermsAndConditionsAccepted(),
                                onChanged: (_) => state is! CreatingUserAccount
                                    ? context
                                        .read<RegistrationBloc>()
                                        .changeAgreementOfTermsAndConditions()
                                    : null,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                contentPadding:
                                    const EdgeInsets.only(left: 5.0),
                                dense: true,
                                title: ExcludeSemantics(
                                  child: RichText(
                                    text: TextSpan(
                                      text:
                                          '${getString(context).i_agree_to} ',
                                      style: const TextStyle(
                                          color: AppColors.gray),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: getString(context)
                                              .terms_and_conditions,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () =>
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight:
                                                          Radius.circular(
                                                        32.0,
                                                      ),
                                                      topLeft:
                                                          Radius.circular(
                                                        32.0,
                                                      ),
                                                    ),
                                                  ),
                                                  isScrollControlled: true,
                                                  builder: (builder) =>
                                                      const TermsAndConditionsDialog(),
                                                ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              LongButton(
                                text: getString(context).register,
                                onClick: context
                                            .watch<RegistrationBloc>()
                                            .isTermsAndConditionsAccepted() &&
                                        state is! CreatingUserAccount
                                    ? () {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();

                                          FocusScope.of(context).unfocus();
                                          context
                                              .read<RegistrationBloc>()
                                              .registerUser();
                                        }
                                      }
                                    : null,
                                isLoading: state is CreatingUserAccount,
                                customStyle: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style!
                                    .copyWith(
                                      backgroundColor: context
                                              .read<RegistrationBloc>()
                                              .isTermsAndConditionsAccepted()
                                          ? MaterialStateProperty.all(
                                              AppColors.primary)
                                          : MaterialStateProperty.all(
                                              AppColors.gray,
                                            ),
                                    ),
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
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 22.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
