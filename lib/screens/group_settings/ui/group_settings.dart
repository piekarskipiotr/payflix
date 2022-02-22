import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/group_helper.dart';
import 'package:payflix/common/validators/group_settings_validation.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_cubit.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'package:payflix/widgets/error_snack_bar.dart';
import 'package:payflix/widgets/full_screen_dialog.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/widgets/success_snack_bar.dart';

class GroupSettings extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const GroupSettings({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isGroupCreator = ModalRoute.of(context)!.settings.arguments as bool;
    return BlocListener<GroupSettingsCubit, GroupSettingsState>(
      listener: (context, state) {
        if (state is CreatingGroupFailed) {
          AppDialogController.showSnackBar(
            context,
            errorSnackBar(
              context,
              GroupHelper.tryConvertErrorCodeToMessage(
                context,
                state.error,
              ),
            ),
          );
        } else if (state is SavingSettingsFailed) {
          AppDialogController.showSnackBar(
            context,
            errorSnackBar(
              context,
              GroupHelper.tryConvertErrorCodeToMessage(
                context,
                state.error,
              ),
            ),
          );
        } else if (state is CreatingGroupSucceeded) {
          AppDialogController.showFullScreenDialog(
            context,
            FullScreenDialog(
              title: getString(context).group_created,
              secondary: getString(context).group_created_secondary,
              animation: lottieSuccess2,
              onClick: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.welcome,
                (route) => false,
              ),
            ),
          );
        } else if (state is SavingSettingsSucceeded) {
          AppDialogController.showSnackBar(
            context,
            successSnackBar(
              context,
              getString(context).saved,
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
              Positioned(
                right: -10.0,
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.only(
                      top: 30.0,
                    ),
                    child: Image.asset(
                      groupFriends,
                      scale: 2.9,
                    ),
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
                        isGroupCreator
                            ? getString(context).create_group
                            : getString(context).group_settings,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.oxygen(
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
                            child: Column(
                              children: [
                                Text(
                                  isGroupCreator
                                      ? getString(context)
                                          .create_group_form_header
                                      : getString(context)
                                          .group_settings_form_header,
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.oxygen(
                                    color: AppColors.creamWhite,
                                    fontSize: 16.0,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  onSaved: (mPayment) => context
                                      .read<GroupSettingsCubit>()
                                      .setMonthlyPayment(mPayment),
                                  validator: (mPayment) =>
                                      GroupSettingsValidation.validatePayment(
                                    context,
                                    mPayment,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        (RegExp(r'^\d+\.?\d{0,2}'))),
                                  ],
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  style: GoogleFonts.oxygen(),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    prefixIcon: const Icon(
                                      Icons.attach_money,
                                      size: 22.0,
                                      color: AppColors.creamWhite,
                                    ),
                                    hintText:
                                        getString(context).monthly_payment,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  onSaved: (dayOfPayment) => context
                                      .read<GroupSettingsCubit>()
                                      .setDayOfTheMonth(dayOfPayment),
                                  validator: (dayOfPayment) =>
                                      GroupSettingsValidation
                                          .validateDayOfPayment(
                                    context,
                                    dayOfPayment,
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  maxLines: 1,
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d{0,2}')),
                                  ],
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.oxygen(),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(right: 10.0),
                                    prefixIcon: const Icon(
                                      Icons.today,
                                      size: 22.0,
                                      color: AppColors.creamWhite,
                                    ),
                                    hintText:
                                        getString(context).day_of_the_month,
                                  ),
                                ),
                                const SizedBox(
                                  height: 30.0,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    getString(context).account_access_optional,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.oxygen(
                                      color: AppColors.creamWhite,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  onSaved: (emailID) => context
                                      .read<GroupSettingsCubit>()
                                      .setEmailID(emailID),
                                  validator: (emailID) =>
                                      GroupSettingsValidation
                                          .validateEmailIdField(
                                    context,
                                    emailID,
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
                                      .read<GroupSettingsCubit>()
                                      .setPassword(password),
                                  maxLines: 1,
                                  textInputAction: TextInputAction.done,
                                  obscureText: true,
                                  style: GoogleFonts.oxygen(),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(right: 10.0),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      size: 22.0,
                                      color: AppColors.creamWhite,
                                    ),
                                    hintText: getString(context).password,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25.0,
                                ),
                                BlocBuilder<GroupSettingsCubit,
                                    GroupSettingsState>(
                                  builder: (context, state) {
                                    return PrimaryButton(
                                      text: isGroupCreator
                                          ? getString(context).create
                                          : getString(context).save,
                                      onClick: state is! SavingSettings &&
                                              state is! CreatingGroup
                                          ? () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                formKey.currentState!.save();
                                                isGroupCreator
                                                    ? context
                                                        .read<
                                                            GroupSettingsCubit>()
                                                        .createGroup(
                                                          GroupType.netflix,
                                                        )
                                                    : context
                                                        .read<
                                                            GroupSettingsCubit>()
                                                        .saveSettings(
                                                          GroupType.netflix,
                                                        );
                                              }
                                            }
                                          : null,
                                      isLoading: state is SavingSettings ||
                                          state is CreatingGroup,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
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
