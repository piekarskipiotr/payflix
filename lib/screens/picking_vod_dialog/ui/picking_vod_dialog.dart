import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';

class PickingVodDialog extends StatelessWidget {
  const PickingVodDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vods = context.read<PickingVodDialogCubit>().getVods();

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
              getString(context).picking_vod_header,
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
              child: BlocBuilder<PickingVodDialogCubit, PickingVodDialogState>(
                builder: (context, state) {
                  final selectedVod =
                      context.read<PickingVodDialogCubit>().getPickedVod();

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
                      for (var vod in vods) ...[
                        Material(
                          elevation: 0,
                          clipBehavior: Clip.antiAlias,
                          type: MaterialType.circle,
                          color: vod == selectedVod
                              ? AppColors.creamWhite
                              : AppColors.containerBlack,
                          child: Padding(
                            padding:
                                EdgeInsets.all(vod == selectedVod ? 4.0 : 0.0),
                            child: Material(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              type: MaterialType.circle,
                              color: context
                                      .read<PickingVodDialogCubit>()
                                      .doesUserHasVodGroupAlready(vod)
                                  ? AppColors.containerBlack.withOpacity(0.6)
                                  : AppColors.containerBlack,
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: AppCachedNetworkImage(
                                        url: vod.logo,
                                        placeholder: defVOD,
                                        color: context
                                                .read<PickingVodDialogCubit>()
                                                .doesUserHasVodGroupAlready(vod)
                                            ? AppColors.creamWhite
                                                .withOpacity(0.2)
                                            : null,
                                        blendMode: BlendMode.modulate,
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        child: context
                                                .read<PickingVodDialogCubit>()
                                                .doesUserHasVodGroupAlready(vod)
                                            ? Container(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.lock,
                                                  size: 36.0,
                                                  color: AppColors.creamWhite
                                                      .withOpacity(0.6),
                                                ),
                                              )
                                            : (vod == selectedVod
                                                ? Container(
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                      Icons.done,
                                                      size: 36.0,
                                                      color:
                                                          AppColors.creamWhite,
                                                    ),
                                                  )
                                                : null),
                                        onTap: context
                                                .read<PickingVodDialogCubit>()
                                                .doesUserHasVodGroupAlready(vod)
                                            ? null
                                            : () => context
                                                .read<PickingVodDialogCubit>()
                                                .pickVod(vod),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
