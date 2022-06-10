import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/group_card.dart';
import 'package:payflix/screens/picking_vod_dialog/ui/picking_vod_dialog.dart';

class Groups extends StatelessWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          pinned: true,
          elevation: 0.0,
          expandedHeight: 200.0,
          backgroundColor: Colors.transparent,
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
            )
          ],
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              var top = constraints.biggest.height;

              return Container(
                decoration: BoxDecoration(
                  gradient:
                      top <= 56.0 ? AppTheme.appBarGradientExperimental : null,
                ),
                child: FlexibleSpaceBar(
                  expandedTitleScale: 2.44,
                  centerTitle: false,
                  titlePadding: const EdgeInsets.only(
                    left: 15.0,
                    right: 15.0,
                    bottom: 13.0,
                  ),
                  title: Text(
                    getString(context).groups,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.oxygen(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.creamWhite,
                    ),
                  ),
                ),
              );
            },
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
              if (state is FetchingGroups) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is FetchingGroupsFailed) {
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
                var groups = context.read<HomeCubit>().getFetchedGroups();

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => GroupCard(
                      group: groups[index],
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
