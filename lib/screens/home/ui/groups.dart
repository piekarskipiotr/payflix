import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/group_card.dart';
import 'package:payflix/screens/picking_vod_dialog/ui/picking_vod_dialog.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        BlocProvider.value(
          value: context.read<HomeCubit>(),
          child: AppBarWithFixedTitle(
            title: getString(context).groups,
            actions: [
              IconButton(
                onPressed: () => AppDialogController.showBottomSheetDialog(
                  context,
                  BlocProvider.value(
                    value: context.read<HomeCubit>().getVodDialogCubit(),
                    child: const PickingVodDialog(),
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.qr_code,
                ),
              ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            top: 25.0,
            right: 25.0,
            left: 25.0,
          ),
          sliver: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is FetchingData) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is FetchingDataFailed) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'smth went wrong :(',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oxygen(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: AppColors.creamWhite,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                );
              } else {
                var groups = context.read<HomeCubit>().getGroups();

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => GroupCard(
                      group: groups[index],
                      isAdmin: context.read<HomeCubit>().isUserGroupAdmin(
                            groups[index],
                          ),
                    ),
                    childCount: groups.length,
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
