import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/registration_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/registration/bloc/registration_bloc.dart';
import 'package:payflix/widgets/static_spacer.dart';

class Registration extends StatelessWidget {
  late final GlobalKey<FormState> _formKey;

  Registration({Key? key}) : super(key: key) {
    _formKey = GlobalKey<FormState>();
  }

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
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getString(context).registration,
                              style: const TextStyle(
                                  fontSize: 48.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
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
                              hintStyle: const TextStyle(color: AppColors.gray),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onSaved: (value) => context
                                .read<RegistrationBloc>()
                                .setEmailId(value),
                            validator: (value) =>
                                RegistrationValidation.validateEmailIdField(
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
                            height: 10.0,
                          ),
                          TextFormField(
                            onChanged: (value) => context
                                .read<RegistrationBloc>()
                                .setPassword(value),
                            validator: (value) =>
                                RegistrationValidation.validatePasswordField(
                                    context, value),
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
                              hintStyle: const TextStyle(color: AppColors.gray),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            onSaved: (value) => context
                                .read<RegistrationBloc>()
                                .setConfirmPassword(value),
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
                              hintStyle: const TextStyle(color: AppColors.gray),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.gray),
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
                            onChanged: (_) => context
                                .read<RegistrationBloc>()
                                .changeAgreementOfTermsAndConditions(),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: const EdgeInsets.only(left: 5.0),
                            dense: true,
                            title: Align(
                              alignment: const Alignment(-1.3, 0),
                              child: ExcludeSemantics(
                                child: RichText(
                                  text: TextSpan(
                                    text: '${getString(context).i_agree_to} ',
                                    style:
                                        const TextStyle(color: AppColors.gray),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: getString(context)
                                            .terms_and_conditions,
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            log('show terms and conditions');
                                          },
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
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: Theme.of(context)
                                  .elevatedButtonTheme
                                  .style!
                                  .copyWith(
                                    backgroundColor: context
                                            .read<RegistrationBloc>()
                                            .isTermsAndConditionsAccepted()
                                        ? MaterialStateProperty.all(
                                            AppColors.primary)
                                        : MaterialStateProperty.all(
                                            AppColors.gray),
                                  ),
                              onPressed: context
                                      .watch<RegistrationBloc>()
                                      .isTermsAndConditionsAccepted()
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();

                                        FocusScope.of(context).unfocus();
                                        context
                                            .read<RegistrationBloc>()
                                            .registerUser();
                                      }
                                    }
                                  : null,
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  getString(context).register,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
