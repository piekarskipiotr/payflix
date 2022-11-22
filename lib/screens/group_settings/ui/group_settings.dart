import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/validators/group_settings_validation.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/group_settings/bloc/group_delete_cubit.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_cubit.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state_listener.dart';
import 'package:payflix/screens/members/bloc/members_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/ui/picking_vod_dialog.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_cubit.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/ui/app_bar_with_moved_title.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
import 'package:payflix/widgets/blur_container.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'delete_group_dialog.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

class GroupSettings extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const GroupSettings({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final bool _isGroupCreator = _args[0];
    final Group? _group = _isGroupCreator ? null : _args[1];
    final MembersCubit? _membersCubit = _isGroupCreator ? null : _args[2];
    context.read<GroupSettingsCubit>().initialize(_args[1]);

    return BlocListener<GroupSettingsCubit, GroupSettingsState>(
      listener: (context, state) => GroupSettingsStateListener.listenToState(context, state),
      child: WillPopScope(
        onWillPop: () async {
          ScaffoldMessenger.of(context).clearSnackBars();
          return true;
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
                    MultiBlocProvider(
                      providers: [
                        BlocProvider.value(value: getIt<AppBarCubit>()),
                        BlocProvider.value(
                            value: context.read<GroupSettingsCubit>()),
                      ],
                      child: AppBarWithMovedTitle(
                        title: _isGroupCreator
                            ? getString(context).create_group
                            : getString(context).group_settings,
                        secondaryText: (_isGroupCreator
                                ? getString(context).create_group
                                : getString(context).group_settings)
                            .replaceAll('\n', ' '),
                        actions: [
                          BlocBuilder<GroupSettingsCubit, GroupSettingsState>(
                            builder: (context, state) => IconButton(
                              onPressed: _group == null
                                  ? () =>
                                      AppDialogController.showBottomSheetDialog(
                                        context: context,
                                        dialog: BlocProvider.value(
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
                                      child: AppCachedNetworkImage(
                                    url: context
                                        .read<GroupSettingsCubit>()
                                        .getVod()
                                        .logo,
                                    placeholder: AppPlaceholder.vod,
                                    size: 38.0,
                                  )),
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                    _isGroupCreator
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
                                    initialValue: _group
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
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.next,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                        (RegExp(r'^\d+\.?\d{0,2}')),
                                      ),
                                    ],
                                    keyboardType: const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    style: GoogleFonts.oxygen(),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 12.0,),
                                        child: BlocBuilder<GroupSettingsCubit, GroupSettingsState>(
                                          builder: (context, state) => DropdownButton<String>(
                                            value: context.watch<GroupSettingsCubit>().getCurrency(),
                                            underline: Container(),
                                            iconSize: 24.0,
                                            borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                18.0,
                                              ),
                                            ),
                                            dropdownColor: AppColors.fieldBlack,
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: AppColors.creamWhite,
                                            ),
                                            alignment: Alignment.centerRight,
                                            onChanged: (value) => context.read<GroupSettingsCubit>().setCurrency(value),
                                            items: [
                                              'PLN',
                                              'USD',
                                              'EURO',
                                              'JPY'
                                            ].map<DropdownMenuItem<String>>(
                                                    (value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value,
                                                    child: Text(
                                                      value,
                                                      style: GoogleFonts.oxygen(),
                                                    ),
                                                  );
                                                }).toList(),
                                          ),
                                        ),
                                      ),
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
                                    initialValue: _group
                                        ?.paymentInfo.dayOfTheMonth
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
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    initialValue: _group
                                        ?.paymentInfo.bankAccountNumber
                                        .toString(),
                                    onSaved: (bankAccountNumber) => context
                                        .read<GroupSettingsCubit>()
                                        .setBankAccountNumber(
                                            bankAccountNumber),
                                    maxLines: 1,
                                    textInputAction: TextInputAction.next,
                                    style: GoogleFonts.oxygen(),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(right: 10.0),
                                      prefixIcon: const Icon(
                                        Icons.account_balance,
                                        size: 22.0,
                                        color: AppColors.creamWhite,
                                      ),
                                      hintText: getString(context)
                                          .bank_account_number,
                                      helperText:
                                          '     ${getString(context).optional.toCapitalized()}',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15.0,
                                  ),
                                  TextFormField(
                                    initialValue: _group
                                        ?.paymentInfo.phoneNumber
                                        .toString(),
                                    onSaved: (phoneNumber) => context
                                        .read<GroupSettingsCubit>()
                                        .setPhoneNumber(phoneNumber),
                                    validator: (phoneNumber) =>
                                        GroupSettingsValidation
                                            .validatePhoneNumber(
                                      context,
                                      phoneNumber,
                                    ),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    maxLines: 1,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    style: GoogleFonts.oxygen(),
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(right: 10.0),
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        size: 22.0,
                                        color: AppColors.creamWhite,
                                      ),
                                      hintText: getString(context).phone_number,
                                      helperText:
                                          '     ${getString(context).optional.toCapitalized()}',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${getString(context).account_access} (${getString(context).optional})',
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
                                        _group?.accessData.emailID.toString(),
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
                                        initialValue: _group
                                            ?.accessData.password
                                            .toString(),
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
                                          contentPadding: const EdgeInsets.only(
                                              right: 10.0),
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
                                              icon: Icon(
                                                context
                                                        .watch<
                                                            GroupSettingsCubit>()
                                                        .isPasswordVisible()
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
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
                                        text: _isGroupCreator
                                            ? getString(context).create
                                            : getString(context).save,
                                        onClick: state is! SavingSettings &&
                                                state is! CreatingGroup
                                            ? () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  formKey.currentState!.save();
                                                  if (_isGroupCreator) {
                                                    context
                                                        .read<
                                                            GroupSettingsCubit>()
                                                        .createGroup();
                                                  } else {
                                                    context
                                                        .read<
                                                            GroupSettingsCubit>()
                                                        .saveSettings(
                                                          _group,
                                                          _membersCubit,
                                                          context,
                                                        );
                                                  }
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
                          if (!_isGroupCreator) ...[
                            const SizedBox(
                              height: 20.0,
                            ),
                            ListTile(
                              onTap: () =>
                                  AppDialogController.showFullScreenDialog(
                                context,
                                BlocProvider.value(
                                  value: getIt<GroupDeleteCubit>(),
                                  child: DeleteGroupDialog(
                                    group: _group!,
                                  ),
                                ),
                              ),
                              title: Text(
                                getString(context).delete_group,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oxygen(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
