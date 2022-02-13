import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'package:payflix/widgets/primary_button.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Container(
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
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  elevation: 0.0,
                  pinned: true,
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
                      getString(context).log_in,
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
                        body: Column(
                          children: [
                            TextFormField(
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
                                suffixIcon: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          right: 15.0,
                                        ),
                                        child: Text(
                                          getString(context).forgot,
                                          style: const TextStyle(
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
                              onClick: () {},
                              isLoading: false,
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Text(
                              getString(context).or,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
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
                                onTap: () => log('continuing with google'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.fieldBlack.withOpacity(0.8),
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
                                          style: const TextStyle(
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
                                onTap: () => log('continuing with apple'),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.fieldBlack.withOpacity(0.8),
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
                                          style: const TextStyle(
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
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: getString(context).no_account_question,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: '  '),
                            TextSpan(
                              text: getString(context).sign_up,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => log('signing up'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
