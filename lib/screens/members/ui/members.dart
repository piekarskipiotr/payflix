import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/resources/app_theme.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/members/bloc/members_cubit.dart';
import 'package:payflix/screens/members/bloc/members_state.dart';
import 'package:payflix/screens/members/ui/invite_card.dart';
import 'package:payflix/screens/members/ui/member_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      var group = ModalRoute.of(context)!.settings.arguments as Group?;
      await context.read<MembersCubit>().initialize(group);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Positioned(
              right: -20.0,
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(
                    top: 48.0,
                  ),
                  child: Image.asset(
                    friends,
                    scale: 2.4,
                  ),
                ),
              ),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  elevation: 0.0,
                  expandedHeight: 200.0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        AppRoutes.groupSettings,
                        arguments: [
                          false,
                          context.read<MembersCubit>().getGroup()
                        ],
                      ),
                      icon: const Icon(
                        Icons.settings,
                      ),
                    )
                  ],
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      var top = constraints.biggest.height;

                      return Container(
                        decoration: BoxDecoration(
                          gradient: top <= 56.0 ? AppTheme.appBarGradientExperimental : null,
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
                            getString(context).members,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.oxygen(
                              fontSize: 28.0,
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
                  sliver: BlocBuilder<MembersCubit, MembersState>(
                    builder: (context, state) {
                      if (state is FetchingMembersSucceeded) {
                        var members = state.members;

                        return SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 25.0,
                            crossAxisSpacing: 25.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return index == 0
                                  ? const InviteCard()
                                  : MemberCard(
                                      user: members[index - 1],
                                    );
                            },
                            childCount: members.length + 1,
                          ),
                        );
                      } else if (state is InitializingGroup ||
                          state is FetchingMembers) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
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
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
