import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';
import 'package:payflix/screens/home/bloc/home_cubit.dart';
import 'package:payflix/screens/home/bloc/home_cubit_listener.dart';
import 'package:payflix/screens/home/bloc/home_state.dart';
import 'package:payflix/screens/home/ui/groups/groups.dart';
import 'package:payflix/screens/home/ui/profile/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pages = [const Groups(), const Profile()];
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) =>
          HomeCubitListener.listenToState(context, state),
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
