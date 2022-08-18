import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/ui/groups/bloc/group_quick_actions_dialog_cubit.dart';

class GroupQuickActionsDialog extends StatelessWidget {
  final Group group;
  final bool isAdmin;

  const GroupQuickActionsDialog(
      {Key? key, required this.group, required this.isAdmin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                onTap: () {},
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
              )
            ],
          ),
          secondChild: Container(),
        ),
      ),
    );
  }
}
