import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/group_settings/bloc/group_delete_cubit.dart';
import 'package:payflix/screens/group_settings/bloc/group_delete_listener.dart';
import 'package:payflix/screens/group_settings/bloc/group_delete_state.dart';
import 'package:payflix/widgets/primary_button.dart';

class DeleteGroupDialog extends StatelessWidget {
  final Group group;

  const DeleteGroupDialog({
    Key? key,
    required this.group,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupDeleteCubit, GroupDeleteState>(
      listener: (context, state) => GroupDeleteStateListener.listenToState(
        context,
        state,
      ),
      child: Scaffold(
        body: SafeArea(
          top: true,
          bottom: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15.0),
                child: SizedBox(
                  height: 30.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: Text(
                        getString(context).delete_group_header,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxygen(
                          fontSize: 38.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.creamWhite,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Lottie.asset(
                      lottieDelete,
                      repeat: true,
                      width: 192.0,
                      height: 192.0,
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: Text(
                        getString(context).delete_group_body,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.oxygen(
                          color: AppColors.creamWhite,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  BlocBuilder<GroupDeleteCubit, GroupDeleteState>(
                    builder: (context, state) => Padding(
                      padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                      child: PrimaryButton(
                        text: getString(context).delete,
                        onClick: () =>
                            context.read<GroupDeleteCubit>().deleteGroup(group),
                        isLoading: state is DeletingGroup,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ListTile(
                    onTap: () => Navigator.pop(context),
                    title: Text(
                      getString(context).close_dialog,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oxygen(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: AppColors.creamWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
