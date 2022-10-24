import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_cubit.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_listener.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

class LaunchingScreen extends StatelessWidget {
  const LaunchingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LaunchingScreenCubit, LaunchingScreenState>(
      listener: (context, state) => LaunchingScreenListener.listenToState(
        context,
        state,
      ),
      child: Scaffold(
        body: SafeArea(
          bottom: true,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Image.asset(
                  'assets/social/payflix_logo_no_padding.png',
                  width: 192.0,
                ),
                const SizedBox(height: 24.0),
                const SizedBox(
                  width: 18.0,
                  height: 18.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                  ),
                ),
                const SizedBox(height: 48.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
