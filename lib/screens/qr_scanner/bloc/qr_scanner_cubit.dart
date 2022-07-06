import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_cubit.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_state.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

@injectable
class QrScannerCubit extends Cubit<QrScannerState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  final DynamicLinksRepository _dynamicLinksRepository;
  final JoiningGroupDialogCubit _joiningGroupDialogCubit;
  late StreamSubscription _joiningGroupDialogCubitSubscription;

  QrScannerCubit(
    this._firestoreRepository,
    this._authRepository,
    this._dynamicLinksRepository,
    this._joiningGroupDialogCubit,
  ) : super(ScanningForData()) {
    _joiningGroupDialogCubitSubscription =
        _joiningGroupDialogCubit.stream.listen((state) {
      if (state is JoiningToGroupCanceled) {
        emit(JoiningGroupCanceled());
      } else if (state is JoiningToGroupSucceeded) {
        emit(AddingUserToGroupCompleted());
      }
    });
  }

  JoiningGroupDialogCubit getJoiningGroupDialogCubit() =>
      _joiningGroupDialogCubit;

  Future validateData(Barcode? barcode) async {
    if (barcode != null) {
      emit(CheckingTheFoundData());

      var link = barcode.code;
      if (link != null) {
        var isValid = link.startsWith('https://payflix.page.link/');

        if (isValid) {
          emit(FoundDataIsCorrect());
          var dynamicLink = await _dynamicLinksRepository
              .instance()
              .getDynamicLink(Uri.parse(link));
          var user = _authRepository.instance().currentUser;

          if (await _validateUser(user)) {
            var uid = user!.uid;
            var link = dynamicLink!.link;

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
        } else {
          emit(FoundDataIsIncorrect());
        }
      } else {
        emit(FoundDataIsIncorrect());
      }
    }
  }

  Future<bool> _validateUser(User? user) async {
    bool isAuth = user != null;
    bool isVerified = user?.emailVerified == true;
    if (isAuth && isVerified) {
      var uid = user.uid;
      var doesUserExistsInDatabase =
          await _firestoreRepository.doesUserExist(docReference: uid);
      return doesUserExistsInDatabase;
    }

    return false;
  }

  @override
  Future<void> close() async {
    await _joiningGroupDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<QrScannerState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
