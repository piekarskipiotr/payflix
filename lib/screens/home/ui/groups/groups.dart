import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/groups/group_card.dart';
import 'package:payflix/screens/picking_vod_dialog/ui/picking_vod_dialog.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';
import 'package:payflix/widgets/state_failed_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Groups extends StatelessWidget {
  final RefreshController controller;

  const Groups({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, isInnerScrolled) => [
        BlocProvider.value(
          value: context.read<HomeCubit>(),
          child: AppBarWithFixedTitle(
            title: getString(context).groups,
            actions: [
              IconButton(
                onPressed: () => AppDialogController.showBottomSheetDialog(
                  context: context,
                  dialog: BlocProvider.value(
                    value: context.read<HomeCubit>().getVodDialogCubit(),
                    child: const PickingVodDialog(),
                  ),
                ),
                icon: const Icon(
                  Icons.add,
                ),
              ),
              IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.qrScanner),
                icon: const Icon(
                  Icons.qr_code_scanner,
                ),
              ),
            ],
          ),
        ),
      ],
      body: SmartRefresher(
        controller: controller,
        header: const ClassicHeader(),
        onRefresh: () async => context.read<HomeCubit>().fetchData(
              isRefresh: true,
            ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
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
                      child: StateFailedView(
                        text: getString(context).fetching_groups_failed,
                        onClick: () => context.read<HomeCubit>().fetchData(
                              isRefresh: false,
                            ),
                      ),
                    );
                  } else {
                    var groups = context.read<HomeCubit>().getGroups();
                    if (groups.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                emptyInSpace,
                                width: 164.0,
                                height: 164.0,
                              ),
                              const SizedBox(height: 32.0,),
                              Text(
                                getString(context).groups_list_empty,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.oxygen(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.creamWhite,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(
                                height: 96.0,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 25.0,
                        crossAxisSpacing: 25.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => BlocProvider.value(
                          value: context.read<HomeCubit>(),
                          child: GroupCard(
                            group: groups[index],
                            user: context.read<HomeCubit>().getPayflixUser()!,
                            isAdmin: context
                                .read<HomeCubit>()
                                .isUserGroupAdmin(groups[index], null),
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
        ),
      ),
    );
  }
}
