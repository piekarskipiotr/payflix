import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
import 'package:payflix/widgets/primary_button.dart';
import 'package:payflix/widgets/secondary_button.dart';

class JoiningGroupDialog extends StatelessWidget {
  final String uid;
  final String groupId;
  final String adminEmailId;

  const JoiningGroupDialog({
    Key? key,
    required this.adminEmailId,
    required this.uid,
    required this.groupId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupType = GroupTypeHelper.getGroupTypeFromGroupId(groupId);

    return Scaffold(
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: BlocBuilder<JoiningGroupDialogCubit, JoiningGroupDialogState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 26.0,
                  ),
                  Text(
                    getString(context).joining_group_dialog_header,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oxygen(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.creamWhite,
                    ),
                  ),
                  const SizedBox(
                    height: 26.0,
                  ),
                  Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: 126.0,
                      width: 126.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          24.0,
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5.0,
                            sigmaY: 5.0,
                          ),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.containerBlack,
                              borderRadius: BorderRadius.circular(
                                24.0,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    top: 15.0,
                                    right: 15.0,
                                    bottom: 15.0,
                                  ),
                                  child: AppCachedNetworkImage(
                                    url: groupType.logo,
                                    placeholder: AppPlaceholder.vod,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 14.0,
                  ),
                  Text(
                    '${getString(context).admin_of_group} \n$adminEmailId',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.oxygen(
                      color: AppColors.creamWhite,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(
                    height: 52.0,
                  ),
                  PrimaryButton(
                    text: getString(context).join,
                    onClick: state is JoiningToGroup
                        ? null
                        : () => context
                            .read<JoiningGroupDialogCubit>()
                            .addUserToGroup(
                              uid,
                              groupId,
                              context,
                            ),
                    isLoading: state is JoiningToGroup,
                  ),
                  const SizedBox(
                    height: 18.0,
                  ),
                  SecondaryButton(
                    text: getString(context).cancel,
                    onClick: state is JoiningToGroup
                        ? null
                        : () {
                            Navigator.pop(context);
                            context
                                .read<JoiningGroupDialogCubit>()
                                .cancelJoining();
                          },
                    isLoading: false,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
