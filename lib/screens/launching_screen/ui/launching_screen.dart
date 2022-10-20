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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset('assets/social/payflix_logo_no_padding.png'),
              const SizedBox(height: 28.0),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
