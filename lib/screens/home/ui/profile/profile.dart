import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/app_dialog_controller.dart';
import 'package:payflix/data/enum/app_placeholder.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/profile/bloc/change_password_dialog_cubit.dart';
import 'package:payflix/screens/home/ui/profile/bloc/delete_account_dialog_cubit.dart';
import 'package:payflix/screens/home/ui/profile/change_password_dialog.dart';
import 'package:payflix/screens/home/ui/profile/delete_account_dialog.dart';
import 'package:payflix/screens/home/ui/profile/edit_profile_dialog.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';
import 'package:payflix/widgets/app_cached_network_image.dart';
import 'package:payflix/widgets/state_failed_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Profile extends StatelessWidget {
  final RefreshController controller;

  const Profile({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, isInnerScrolled) => [
        AppBarWithFixedTitle(
          title: getString(context).profile,
          actions: null,
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
            SliverFillRemaining(
              hasScrollBody: false,
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is FetchingData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FetchingDataFailed) {
                    return StateFailedView(
                      text: getString(context).profile_user_null,
                      onClick: () => context.read<HomeCubit>().fetchData(
                            isRefresh: false,
                          ),
                    );
                  } else {
                    var user = context.read<HomeCubit>().getPayflixUser();

                    if (user == null) {
                      return StateFailedView(
                        text: getString(context).profile_user_null,
                        onClick: () => context.read<HomeCubit>().fetchData(
                              isRefresh: false,
                            ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25.0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    SizedBox(
                                      width: 72.0,
                                      height: 72.0,
                                      child: Material(
                                        elevation: 0,
                                        clipBehavior: Clip.hardEdge,
                                        type: MaterialType.circle,
                                        color: user.avatar.background,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: AppCachedNetworkImage(
                                                  url: user.avatar.url,
                                                  placeholder:
                                                      AppPlaceholder.avatar,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4.0,
                                          top: 4.0,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user.displayName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.oxygen(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.creamWhite,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 1.0,
                                            ),
                                            Text(
                                              user.email,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.oxygen(
                                                fontSize: 13.0,
                                                color: AppColors.gray,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: () => AppDialogController
                                        .showFullScreenDialog(
                                      context,
                                      BlocProvider.value(
                                        value: context
                                            .read<HomeCubit>()
                                            .getProfileEditCubit()
                                          ..initUser(
                                            user,
                                          ),
                                        child: EditProfileDialog(
                                          user: user,
                                          formKey: GlobalKey<FormState>(),
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      getString(context).edit,
                                      style: GoogleFonts.oxygen(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 45.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 60.0),
                            child: Text(
                              getString(context).manage_account,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          ListTile(
                            onTap: () =>
                                AppDialogController.showFullScreenDialog(
                              context,
                              BlocProvider.value(
                                value: getIt<ChangePasswordDialogCubit>(),
                                child: ChangePasswordDialog(
                                  formKey: GlobalKey<FormState>(),
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            title: Text(
                              getString(context).change_password,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                color: AppColors.creamWhite,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 60.0),
                            child: Text(
                              getString(context)
                                  .app_latest_information('1.0.0-alpha'),
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          ListTile(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.changelog),
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            title: Text(
                              getString(context).change_log,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                color: AppColors.creamWhite,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 60.0),
                            child: Divider(
                              height: 1,
                              color: AppColors.containerBlack,
                            ),
                          ),
                          ListTile(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.support),
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            title: Text(
                              getString(context).support,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                color: AppColors.creamWhite,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 60.0),
                            child: Divider(
                              height: 1,
                              color: AppColors.containerBlack,
                            ),
                          ),
                          ListTile(
                            onTap: () => Navigator.pushNamed(context, AppRoutes.acknow),
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            title: Text(
                              getString(context).acknowledgments,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                color: AppColors.creamWhite,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, right: 60.0),
                            child: Text(
                              getString(context).others,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: AppColors.gray,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          ListTile(
                            onTap: () => context.read<HomeCubit>().logOut(),
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            title: Text(
                              getString(context).log_out,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                color: AppColors.creamWhite,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 20.0, right: 60.0),
                            child: Divider(
                              height: 1,
                              color: AppColors.containerBlack,
                            ),
                          ),
                          ListTile(
                            onTap: () =>
                                AppDialogController.showFullScreenDialog(
                              context,
                              BlocProvider.value(
                                value: getIt<DeleteAccountDialogCubit>(),
                                child: DeleteAccountDialog(
                                  user: user,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(left: 25.0),
                            title: Text(
                              getString(context).delete_account,
                              style: GoogleFonts.oxygen(
                                fontSize: 16.0,
                                color: AppColors.red,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                        ],
                      );
                    }
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
