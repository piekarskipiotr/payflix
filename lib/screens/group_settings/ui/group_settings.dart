import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/group_settings_validation.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_cubit.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state_listener.dart';
import 'package:payflix/screens/picking_vod_dialog/ui/picking_vod_dialog.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSettings extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const GroupSettings({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final bool isGroupCreator = args[0];
    final Group? group = isGroupCreator ? null : args[1];
    context.read<GroupSettingsCubit>().initializeVod(args[1]);

    return BlocListener<GroupSettingsCubit, GroupSettingsState>(
      listener: (context, state) =>
          GroupSettingsStateListener.listenToState(context, state),
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
                      top: 40.0,
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
                    pinned: true,
                    elevation: 0.0,
                    expandedHeight: 200.0,
                    backgroundColor: Colors.transparent,
                    actions: [
                      IconButton(
                        onPressed: group == null
                            ? () => AppDialogController.showBottomSheetDialog(
                                  context,
                                  BlocProvider.value(
                                    value: context
                                        .read<GroupSettingsCubit>()
                                        .getVodDialogCubit(),
                                    child: const PickingVodDialog(),
                                  ),
                                )
                            : null,
                        iconSize: 38.0,
                        icon: Material(
                          elevation: 0,
                          clipBehavior: Clip.hardEdge,
                          color: AppColors.containerBlack,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              16.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: Image.asset(
                                context
                                    .read<GroupSettingsCubit>()
                                    .getVod()
                                    .logo,
                                width: 38.0,
                                height: 38.0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity:
                          context.watch<GroupSettingsCubit>().showRegularTitle()
                              ? 1.0
                              : 0.0,
                      child: Text(
                        (isGroupCreator
                                ? getString(context).create_group
                                : getString(context).group_settings)
                            .replaceAll('\n', ' '),
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
                        context.read<GroupSettingsCubit>().handleTitle(top);

                        return Container(
                          decoration: BoxDecoration(
                            gradient: top <= 56.0
                                ? AppTheme.appBarGradientExperimental
                                : null,
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
                              opacity:
                                  top > regularTitleTopValue + 10.0 ? 1.0 : 0.0,
                              child: Text(
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
                        );
                      },
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
                                  initialValue: group
                                      ?.paymentInfo.monthlyPayment
                                      .toString(),
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
                                  initialValue: group?.paymentInfo.dayOfTheMonth
                                      .toString(),
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
                                  initialValue:
                                      group?.accessData.emailID.toString(),
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
                                BlocBuilder<GroupSettingsCubit,
                                    GroupSettingsState>(
                                  builder: (context, state) {
                                    return TextFormField(
                                      initialValue:
                                          group?.accessData.password.toString(),
                                      onSaved: (password) => context
                                          .read<GroupSettingsCubit>()
                                          .setPassword(password),
                                      maxLines: 1,
                                      textInputAction: TextInputAction.done,
                                      obscureText: context
                                          .watch<GroupSettingsCubit>()
                                          .isPasswordVisible(),
                                      style: GoogleFonts.oxygen(),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.only(right: 10.0),
                                        hintText: getString(context).password,
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          size: 22.0,
                                          color: AppColors.creamWhite,
                                        ),
                                        suffixIcon: Material(
                                          color: Colors.transparent,
                                          child: IconButton(
                                            onPressed: () => context
                                                .read<GroupSettingsCubit>()
                                                .changePasswordVisibility(),
                                            splashRadius: 20.0,
                                            icon: const Icon(
                                              Icons.visibility_off,
                                              size: 22.0,
                                              color: AppColors.creamWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
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
