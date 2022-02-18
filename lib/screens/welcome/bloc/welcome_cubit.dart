import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state.dart';

class WelcomeCubit extends Cubit<WelcomeState> {
  WelcomeCubit() : super(InitWelcomeState());

  @override
  void onChange(Change<WelcomeState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
