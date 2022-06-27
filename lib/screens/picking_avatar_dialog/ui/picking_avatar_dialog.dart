import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/data/model/avatar.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/picking_avatar_dialog/bloc/picking_avatar_dialog_state.dart';

class PickingAvatarDialog extends StatelessWidget {
  final Avatar? initialAvatar;
  const PickingAvatarDialog({Key? key, this.initialAvatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var avatars = context.read<PickingAvatarDialogCubit>().getAvatars();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 20.0),
        child: Column(
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
            Text(
              getString(context).picking_avatar_header,
              style: GoogleFonts.oxygen(
                color: AppColors.creamWhite,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                top: 10.0,
                right: 15.0,
              ),
              child: BlocBuilder<PickingAvatarDialogCubit,
                  PickingAvatarDialogState>(
                builder: (context, state) {
                  Avatar? selectedAvatar;
                  if (state is AvatarPicked) {
                    selectedAvatar = state.avatar;
                  }

                  Avatar? getAvatar() => selectedAvatar ?? initialAvatar;

                  return GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 35.0,
                      crossAxisSpacing: 35.0,
                    ),
                    children: [
                      for (var index = 0; index < avatars.length; index++)

                        Material(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          type: MaterialType.circle,
                          color: avatars[index] == getAvatar()
                              ? AppColors.creamWhite
                              : avatars[index].background,
                          child: Padding(
                            padding: EdgeInsets.all(
                                avatars[index] == getAvatar() ? 4.0 : 0.0),
                            child: Material(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              type: MaterialType.circle,
                              color: avatars[index].background,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 8.0,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Image.network(
                                            avatars[index].url,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        child: avatars[index] == getAvatar()
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: const Icon(
                                                  Icons.done,
                                                  size: 36.0,
                                                  color: AppColors.creamWhite,
                                                ),
                                              )
                                            : null,
                                        onTap: () => context
                                            .read<PickingAvatarDialogCubit>()
                                            .pickAvatar(avatars[index]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
