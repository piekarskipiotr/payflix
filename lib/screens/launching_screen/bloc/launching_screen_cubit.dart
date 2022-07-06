import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/app_hive.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/resources/routes/app_routes.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';
import 'package:payflix/screens/launching_screen/bloc/launching_screen_state.dart';

@injectable
class LaunchingScreenCubit extends Cubit<LaunchingScreenState> {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final DynamicLinksRepository _dynamicLinksRepository;
  final JoiningGroupDialogCubit _joiningGroupDialogCubit;
  late StreamSubscription _joiningGroupDialogCubitSubscription;

  LaunchingScreenCubit(
    this._authRepository,
    this._firestoreRepository,
    this._dynamicLinksRepository,
    this._joiningGroupDialogCubit,
  ) : super(InitLaunchingScreenState()) {
    _initialize();

    _joiningGroupDialogCubitSubscription =
        _joiningGroupDialogCubit.stream.listen((state) {
          if (state is JoiningToGroupCanceled) {
            emit(JoiningGroupCanceled());
          } else if (state is JoiningToGroupSucceeded) {
            emit(AddingUserToGroupCompleted());
          }
        });

    _dynamicLinksRepository.instance().onLink.listen((dynamicLinkData) async {
      emit(ReceivingLink());
      var link = dynamicLinkData.link;
      var user = _authRepository.instance().currentUser;

      bool isAuth = user != null;
      bool isVerified = user?.emailVerified == true;
      if (isAuth && isVerified) {
        var uid = user.uid;
        var doesUserExistsInDatabase =
            await _firestoreRepository.doesUserExist(docReference: uid);

        if (doesUserExistsInDatabase) {
          await _handleLink(uid, link);
        } else {
          await _saveDynamicLink(link);
        }
      } else {
        await _saveDynamicLink(link);
      }
    });
  }

  Future _handleLink(String uid, Uri link) async {
    var inviteId = link.queryParametersAll['id']!.first;
    var inviteInfo = await _firestoreRepository.getGroupInviteData(
        docReference: inviteId);
    var groupId = inviteInfo!.groupId;

    if (await _firestoreRepository.doesUserIsInGroup(
        docReference: uid, groupId: groupId)) {
      emit(UserIsAlreadyInThisGroup());
    } else if (await _firestoreRepository.doesUserIsInVODGroup(
        docReference: uid, groupId: groupId)) {
      emit(UserIsAlreadyInThisVodGroup());
    } else {
      var email = await _firestoreRepository.getAdminEmailByGroupId(
          groupId: groupId);
      emit(UserCanBeAddedToTheGroup(email, uid, groupId));
    }
  }

  JoiningGroupDialogCubit getJoiningGroupDialogCubit() =>
      _joiningGroupDialogCubit;

  Future _saveDynamicLink(Uri link) async =>
      await invitesBox.put(dynamicLinkKey, link);

  Future _initialize() async {
    emit(InitializingApp());

    var initialLink = await _dynamicLinksRepository.instance().getInitialLink();

    Uri? link;
    if (initialLink != null) {
      link = initialLink.link;
      await _saveDynamicLink(link);
    }

    String? route;
    var user = _authRepository.instance().currentUser;

    bool isAuth = user != null;
    bool isVerified = user?.emailVerified == true;

    if (isAuth && isVerified) {
      var uid = user.uid;
      var doesUserExistsInDatabase =
          await _firestoreRepository.doesUserExist(docReference: uid);

      if (doesUserExistsInDatabase) {
        if (link != null) {
          await _handleLink(uid, link);
        }

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
  Future<void> close() async {
    await _joiningGroupDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<LaunchingScreenState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
