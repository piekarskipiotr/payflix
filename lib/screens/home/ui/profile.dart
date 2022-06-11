import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/widgets/app_bar_with_fixed_title.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        AppBarWithFixedTitle(
          title: getString(context).profile,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.qr_code,
              ),
            ),
          ],
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is FetchingData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is FetchingDataFailed) {
                return Center(
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
                );
              } else {
                var user = context.read<HomeCubit>().getPayflixUser();

                if (user == null) {
                  return Center(
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
                          Row(
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
                                  color: context
                                      .read<HomeCubit>()
                                      .getColor(user.avatarID),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Image.asset(
                                            context
                                                .read<HomeCubit>()
                                                .getAvatar(user.avatarID),
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
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 4.0,
                                  top: 4.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.displayName,
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
                                      style: GoogleFonts.oxygen(
                                        fontSize: 13.0,
                                        color: AppColors.gray,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            getString(context).edit_profile,
                            style: GoogleFonts.oxygen(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 45.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 60.0),
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
                        onTap: () {},
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
                        padding: const EdgeInsets.only(left: 25.0, right: 60.0),
                        child: Text(
                          getString(context).app_latest_information(
                              '1.0.0-alpha', '11.06.2022'),
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
                        onTap: () {},
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
                        onTap: () {},
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
                        onTap: () {},
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
                        padding: const EdgeInsets.only(left: 25.0, right: 60.0),
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
                        onTap: () {},
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
                        onTap: () {},
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
    );
  }
}
