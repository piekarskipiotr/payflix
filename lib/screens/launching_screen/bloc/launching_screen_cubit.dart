import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

@injectable
class LaunchingScreenCubit extends Cubit<LaunchingScreenState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  LaunchingScreenCubit(this._authRepo, this._firestoreRepository)
      : super(InitLaunchingScreenState());

  Future initialize() async {
    emit(CheckingUserData());

    String? route;
    var user = _authRepo.instance().currentUser;

    bool isAuth = user != null;
    bool isVerified = user?.emailVerified == true;

    if (isAuth && isVerified) {
      var uid = user.uid;
      var doesUserExistsInDatabase =
          await _firestoreRepository.doesUserExist(docReference: uid);

      if (doesUserExistsInDatabase) {
        var doesUserIsInGroup =
            await _firestoreRepository.doesUserIsInGroup(docReference: uid);
        route = doesUserIsInGroup ? AppRoutes.members : AppRoutes.welcome;
      } else {
        await _authRepo.instance().signOut();
        route = AppRoutes.login;
      }
    } else if (isAuth && !isVerified) {
      route = AppRoutes.verRoom;
    } else {
      route = AppRoutes.login;
    }

    /*
    this await Future delayed is cuz there is case that app emit this state
    when app isn't launched yet???? and cubit listener won't respond to that
    emit
     */
    await Future.delayed(const Duration(seconds: 1));
    emit(StartingApp(route));
  }

  @override
  void onChange(Change<LaunchingScreenState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
