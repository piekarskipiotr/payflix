import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/login_validation.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/login/bloc/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatelessWidget {
  late final GlobalKey<FormState> _formKey;

  Login({Key? key}) : super(key: key) {
    _formKey = GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 15.0,
                ),
                Image.asset(welcomeHumanImage),
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
                          getString(context).login,
                          style: const TextStyle(
                              fontSize: 48.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        onSaved: (value) => context.read<LoginBloc>().setEmailId(value),
                        validator: (value) =>
                            LoginValidation.validateEmailIdField(
                                context, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.center,
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
                        onSaved: (value) => context.read<LoginBloc>().setPassword(value),
                        validator: (value) =>
                            LoginValidation.validatePasswordField(
                                context, value),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: 1,
                        textAlignVertical: TextAlignVertical.center,
                        obscureText: true,
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
                                onTap: () =>
                                    context.read<LoginBloc>().restartPassword(),
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
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              context
                                  .read<LoginBloc>()
                                  .authenticateUserByForm();
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              getString(context).login,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
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
                                ..onTap = () => Navigator.pushNamed(
                                    context, AppRoutes.registration),
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
                      Text(
                        getString(context).login_register_with,
                        textAlign: TextAlign.center,
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
                              onPressed: () => context
                                  .read<LoginBloc>()
                                  .authenticateUserByGoogleAccount(),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                              onPressed: () => context
                                  .read<LoginBloc>()
                                  .authenticateUserByAppleAccount(),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
