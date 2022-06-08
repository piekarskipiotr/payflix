import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/app_hive.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

@injectable
class LaunchingScreenCubit extends Cubit<LaunchingScreenState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepo;
  final DynamicLinksRepository _dynamicLinksRepo;

  LaunchingScreenCubit(
      this._authRepo, this._firestoreRepo, this._dynamicLinksRepo)
      : super(InitLaunchingScreenState()) {
    _dynamicLinksRepo.instance().onLink.listen((dynamicLinkData) async {
      emit(ReceivingLink());
      var link = dynamicLinkData.link;
      var user = _authRepo.instance().currentUser;

      bool isAuth = user != null;
      bool isVerified = user?.emailVerified == true;
      if (isAuth && isVerified) {
        var uid = user.uid;
        var doesUserExistsInDatabase =
            await _firestoreRepo.doesUserExist(docReference: uid);

        if (doesUserExistsInDatabase) {
          await _addUserToGroup(uid, link);
        } else {
          await _saveDynamicLink(link);
        }
      } else {
        await _saveDynamicLink(link);
      }
    });
  }

  Future _addUserToGroup(String uid, Uri link) async {
    emit(AddingUserToGroup());
    var inviteId = link.queryParametersAll['id']!.first;
    var inviteInfo = await _firestoreRepo.getGroupInviteData(docReference: inviteId);
    var groupId = inviteInfo!.groupId;

    if (await _firestoreRepo.doesUserIsInGroup(docReference: uid, groupId: groupId)) {
      emit(UserIsAlreadyInThisGroup());

    } else {
      await _firestoreRepo.updateUserData(
        docReference: uid,
        data: {
          "groups": FieldValue.arrayUnion([groupId])
        },
      );

      emit(AddingUserToGroupCompleted());
    }
  }

  Future _saveDynamicLink(Uri link) async => await invitesBox.put(dynamicLinkKey, link);

  Future initialize() async {
    emit(CheckingUserData());
    final initialLink = await _dynamicLinksRepo.instance().getInitialLink();
    if (initialLink != null) {
      final deepLink = initialLink.link;
      await _saveDynamicLink(deepLink);
    }

    String? route;
    var user = _authRepo.instance().currentUser;

    bool isAuth = user != null;
    bool isVerified = user?.emailVerified == true;

    if (isAuth && isVerified) {
      var uid = user.uid;
      var doesUserExistsInDatabase =
          await _firestoreRepo.doesUserExist(docReference: uid);

      if (doesUserExistsInDatabase) {
        var doesUserIsInGroup =
            await _firestoreRepo.doesUserHasAGroup(docReference: uid);
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
    await Future.delayed(const Duration(milliseconds: 30));
    emit(StartingApp(route));
  }

  @override
  void onChange(Change<LaunchingScreenState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
