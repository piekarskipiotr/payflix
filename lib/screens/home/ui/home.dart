import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/app_listener_bloc/app_listener.dart';
import 'package:payflix/app_listener_bloc/app_listener_cubit.dart';
import 'package:payflix/app_listener_bloc/app_listener_state.dart';
import 'package:payflix/di/get_it.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_cubit_listener.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/groups/groups.dart';
import 'package:payflix/screens/home/ui/profile/profile.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _pageIndex = 0;
  late RefreshController _groupsController;
  late RefreshController _profileController;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _groupsController = RefreshController(initialRefresh: false);
    _profileController = RefreshController(initialRefresh: false);

    _pages = [
      Groups(controller: _groupsController),
      Profile(controller: _profileController),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) => HomeCubitListener.listenToState(
            context,
            state,
            _groupsController,
            _profileController,
          ),
        ),
        BlocListener<AppListenerCubit, AppListenerState>(
          listener: (context, state) => AppListener.listenToState(
            context,
            state,
            getIt<JoiningGroupDialogCubit>(),
          ),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          top: true,
          bottom: true,
          child: BlocProvider.value(
            value: context.read<HomeCubit>(),
            child: _pages[_pageIndex],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (index) => setState(() => _pageIndex = index),
          iconSize: 28.0,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.groups),
              label: getString(context).groups,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: getString(context).profile,
            ),
          ],
        ),
      ),
    );
  }
}
