import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/login_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/create_group/bloc/create_group_bloc.dart';
import 'package:payflix/screens/create_group/bloc/create_group_state.dart';
import 'package:payflix/widgets/long_button.dart';
import 'package:payflix/widgets/static_spacer.dart';

class CreateGroup extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const CreateGroup({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0.0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 22.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        getString(context).create_group,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 42.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 50.0,
                      ),
                      Image.asset(
                        familyOnCoach,
                      ),
                      staticSpacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Text(
                          getString(context).create_group_subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      staticSpacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: const Icon(
                                    Icons.attach_money,
                                    color: AppColors.gray,
                                  ),
                                  hintText: getString(context).monthly_payment,
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  helperText: getString(context)
                                      .monthly_payment_description,
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
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                obscureText: true,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  prefixIcon: const Icon(
                                    Icons.today,
                                    color: AppColors.gray,
                                  ),
                                  hintText: getString(context).day_of_payment,
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),
                                ),
                              ),
                              staticSpacer(),
                              Text(
                                getString(context).access_account_data,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              staticSpacer(),
                              TextFormField(
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
                                  hintStyle:
                                      const TextStyle(color: AppColors.gray),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: AppColors.gray),
                                  ),
                                ),
                              ),
                              staticSpacer(),
                              BlocBuilder<CreateGroupBloc, CreateGroupState>(
                                builder: (context, state) {
                                  return LongButton(
                                      text: getString(context).create_group.replaceAll('\n', ' '),
                                      isLoading: false,
                                      onClick: () {
                                        if (formKey.currentState!.validate()) {}
                                      });
                                },
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
