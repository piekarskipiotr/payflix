import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state.dart';

@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  WelcomeCubit(this._authRepo, this._firestoreRepository)
      : super(InitWelcomeState());

  Future checkIfAlreadySeen(BuildContext context) async {
    emit(CheckingWelcomeState());

    var uid = _authRepo.getUID();
    var box = await Hive.openBox('user$uid');
    var shouldRouteToHome =
        box.get('welcome-screen-state', defaultValue: false);
    if (!shouldRouteToHome) {
      box.put('welcome-screen-state', true);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
            (route) => false,
      );
    }

    emit(CheckingWelcomeStateCompleted());
  }

  Future isAlreadyInGroup() async {
    var uid = _authRepo.getUID();
    var user = await _firestoreRepository.getUserData(docReference: uid!);
    if (user.groups.isNotEmpty) {
      var groupData = await _firestoreRepository.getGroupData(
          docReference: user.groups.first);
      emit(NavigateToGroup(groupData));
    }
  }

  @override
  void onChange(Change<WelcomeState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
