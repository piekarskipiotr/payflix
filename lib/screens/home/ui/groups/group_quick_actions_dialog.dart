import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_cubit.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';

import 'bloc/group_quick_actions_dialog_listener.dart';
import 'bloc/group_quick_actions_dialog_state.dart';

class GroupQuickActionsDialog extends StatelessWidget {
  final Group group;
  final bool isAdmin;

  static const _accountAccessActionCode = 'account-access';
  static const _paymentInfoActionCode = 'payment-info';
  static const _adminContactActionCode = 'admin-contact';
  static const _leaveGroupActionCode = 'leave-group';

  const GroupQuickActionsDialog(
      {Key? key, required this.group, required this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupQuickActionsDialogCubit,
        GroupQuickActionsDialogState>(
      listener: (context, state) =>
          GroupQuickActionsDialogListener.listenToState(
        context,
        state,
      ),
      child: SingleChildScrollView(
        child: AnimatedContainer(
          padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
          duration: const Duration(milliseconds: 200),
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                context.watch<GroupQuickActionsDialogCubit>().showSecondary()
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            firstChild: Column(
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
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.only(left: 22.0),
                  leading: const Icon(Icons.lock_open),
                  title: Text(
                    getString(context).account_access,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.oxygen(
                      color: AppColors.creamWhite,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {},
                  contentPadding: const EdgeInsets.only(left: 22.0),
                  leading: const Icon(Icons.monetization_on_outlined),
                  title: Text(
                    getString(context).payment_info,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.oxygen(
                      color: AppColors.creamWhite,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                if (!isAdmin) ...[
                  ListTile(
                    onTap: () {},
                    contentPadding: const EdgeInsets.only(left: 22.0),
                    leading: const Icon(Icons.person_outline),
                    title: Text(
                      getString(context).admin_contact,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oxygen(
                        color: AppColors.creamWhite,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () =>
                        context.read<GroupQuickActionsDialogCubit>().changeView(
                              action: 'leave-group',
                            ),
                    contentPadding: const EdgeInsets.only(left: 22.0),
                    leading: const Icon(
                      Icons.login,
                      color: AppColors.red,
                    ),
                    title: Text(
                      getString(context).leave_group,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.oxygen(
                        color: AppColors.red,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            secondChild: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
              ),
              child: BlocBuilder<GroupQuickActionsDialogCubit,
                  GroupQuickActionsDialogState>(
                builder: (context, state) => _secondChild(
                  context,
                  state,
                  context
                      .read<GroupQuickActionsDialogCubit>()
                      .getActionCodeName(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _secondChild(
    BuildContext context,
    GroupQuickActionsDialogState state,
    String action,
  ) {
    switch (action) {
      case _accountAccessActionCode:
        return _accountAccess(context, state);
      case _paymentInfoActionCode:
        return _paymentInfo(context, state);
      case _adminContactActionCode:
        return _adminContact(context, state);
      case _leaveGroupActionCode:
        return _leaveGroup(context, state);
      default:
        return Container();
    }
  }

  Widget _accountAccess(
    BuildContext context,
    GroupQuickActionsDialogState state,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [],
    );
  }

  Widget _paymentInfo(
    BuildContext context,
    GroupQuickActionsDialogState state,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [],
    );
  }

  Widget _adminContact(
    BuildContext context,
    GroupQuickActionsDialogState state,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [],
    );
  }

  Widget _leaveGroup(
    BuildContext context,
    GroupQuickActionsDialogState state,
  ) {
    return Column(
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
          height: 12.0,
        ),
        SizedBox(
          width: 168.0,
          height: 168.0,
          child: Lottie.asset(
            lottieWarning,
            repeat: true,
          ),
        ),
        const SizedBox(
          height: 7.0,
        ),
        Text(
          getString(context).leave_group_header,
          style: GoogleFonts.oxygen(
            color: AppColors.creamWhite,
            fontWeight: FontWeight.bold,
            fontSize: 26.0,
          ),
        ),
        const SizedBox(
          height: 7.0,
        ),
        Text(
          getString(context).leave_group_body,
          style: GoogleFonts.oxygen(
            color: AppColors.creamWhite,
            fontSize: 15.0,
          ),
        ),
        const SizedBox(
          height: 64.0,
        ),
        PrimaryButton(
          text: getString(context).leave_group,
          onClick: () =>
              context.read<GroupQuickActionsDialogCubit>().leaveGroup(
                    group,
                  ),
          isLoading: state is LeavingGroup,
        ),
        const SizedBox(
          height: 18.0,
        ),
        SecondaryButton(
          text: getString(context).back,
          isLoading: false,
          onClick: state is LeavingGroup
              ? null
              : () => context.read<GroupQuickActionsDialogCubit>().changeView(
                    action: '',
                  ),
        ),
      ],
    );
  }
}
