import 'package:flutter/material.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/members/bloc/members_cubit.dart';
import 'package:payflix/screens/members/bloc/members_listener.dart';
import 'package:payflix/screens/members/bloc/members_state.dart';
import 'package:payflix/screens/members/ui/invite_card.dart';
import 'package:payflix/screens/members/ui/member_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/bloc/app_bar_cubit.dart';
import 'package:payflix/widgets/app_bar_with_moved_title/ui/app_bar_with_moved_title.dart';
import 'package:payflix/widgets/state_failed_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Members extends StatefulWidget {
  const Members({Key? key}) : super(key: key);

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final _controller = RefreshController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final group = args[0] as Group;
    final homeCubit = args[1] as HomeCubit;

    context.read<MembersCubit>().initialize(group);

    return BlocListener<MembersCubit, MembersState>(
      listener: (context, state) => MembersListener.listenToState(
        context,
        state,
        _controller,
      ),
      child: Scaffold(
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
              NestedScrollView(
                headerSliverBuilder: (context, isInnerScrolled) => [
                  MultiBlocProvider(
                    providers: [
                      BlocProvider.value(value: getIt<AppBarCubit>()),
                      BlocProvider.value(value: context.read<MembersCubit>()),
                    ],
                    child: AppBarWithMovedTitle(
                      title:
                          '${group.groupType.vodName}\n${getString(context).members}',
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
                    ),
                  ),
                ],
                body: SmartRefresher(
                  controller: _controller,
                  header: const ClassicHeader(),
                  onRefresh: () async =>
                      context.read<MembersCubit>().refreshData(
                            cubit: homeCubit,
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
                                        ? InviteCard(
                                            groupType: group.groupType,
                                          )
                                        : MemberCard(
                                            user: members[index - 1],
                                            isCurrentUser: context
                                                .read<MembersCubit>()
                                                .isCurrentUser(
                                                    members[index - 1]),
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
                                child: StateFailedView(
                                  text:
                                      getString(context).fetching_members_error,
                                  onClick: () => context
                                      .read<MembersCubit>()
                                      .initialize(group),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
