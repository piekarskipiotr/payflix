import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/app_listener_bloc/app_listener_state.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/app_hive.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';

@injectable
class AppListenerCubit extends Cubit<AppListenerState> {
  final AuthRepository _authRepository;
  final FirestoreRepository _firestoreRepository;
  final DynamicLinksRepository _dynamicLinksRepository;
  final JoiningGroupDialogCubit _joiningGroupDialogCubit;
  late StreamSubscription _joiningGroupDialogCubitSubscription;

  AppListenerCubit(
    this._joiningGroupDialogCubit,
    this._authRepository,
    this._firestoreRepository,
    this._dynamicLinksRepository,
  ) : super(InitAppListenerState()) {
    _dynamicLinksRepository.instance().onLink.listen((dynamicLinkData) async {
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

    _joiningGroupDialogCubitSubscription =
        _joiningGroupDialogCubit.stream.listen((state) {
      if (state is JoiningToGroupCanceled) {
        emit(AddingUserToGroupCanceled());
      } else if (state is JoiningToGroupSucceeded) {
        emit(AddingUserToGroupSucceeded());
      }
    });
  }

  Future _saveDynamicLink(Uri link) async =>
      await invitesBox.put(dynamicLinkKey, link);

  Future _handleLink(String uid, Uri link) async {
    var inviteId = link.queryParametersAll['id']!.first;
    var inviteInfo = await _firestoreRepository.getGroupInviteData(
        docReference: inviteId);
    var groupId = inviteInfo!.groupId;

    if (await _firestoreRepository.doesUserIsInGroup(
        docReference: uid, groupId: groupId)) {
      emit(AlreadyInGroup());
    } else if (await _firestoreRepository.doesUserIsInVODGroup(
        docReference: uid, groupId: groupId)) {
      emit(AlreadyInThisVodGroup());
    } else {
      var email = await _firestoreRepository.getAdminEmailByGroupId(
          groupId: groupId);
      emit(DisplayingJoinDialog(email, uid, groupId));
    }
  }

  JoiningGroupDialogCubit getJoiningGroupDialogCubit() =>
      _joiningGroupDialogCubit;

  @override
  Future<void> close() async {
    await _joiningGroupDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<AppListenerState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
