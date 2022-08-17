import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

@injectable
class LaunchingScreenCubit extends Cubit<LaunchingScreenState> {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;

  LaunchingScreenCubit(
    this._authRepository,
    this._firestoreRepository,
  ) : super(InitLaunchingScreenState()) {
    Future.delayed(const Duration(seconds: 1), () async => await _initialize());
  }

  Future _initialize() async {
    emit(InitializingApp());

    String? route;
    var user = _authRepository.instance().currentUser;

    bool isAuth = user != null;
    bool isVerified = user?.emailVerified == true;

    if (isAuth && isVerified) {
      var uid = user.uid;
      var doesUserExistsInDatabase =
          await _firestoreRepository.doesUserExist(docReference: uid);

      if (doesUserExistsInDatabase) {
        var doesUserIsInGroup =
            await _firestoreRepository.doesUserHasAGroup(docReference: uid);
        route = doesUserIsInGroup ? AppRoutes.home : AppRoutes.welcome;
      } else {
        await _authRepository.instance().signOut();
        route = AppRoutes.login;
      }
    } else if (isAuth && !isVerified) {
      route = AppRoutes.verRoom;
    } else {
      route = AppRoutes.login;
    }

    emit(StartingApp(route));
  }

  @override
  void onChange(Change<LaunchingScreenState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
