import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/qr_scanner/bloc/qr_scanner_state.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

@injectable
class QrScannerCubit extends Cubit<QrScannerState> {
  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  final DynamicLinksRepository _dynamicLinksRepository;

  QrScannerCubit(this._firestoreRepository, this._authRepository, this._dynamicLinksRepository) : super(ScanningForData());

  Future validateData(Barcode? barcode) async {
    if (barcode != null) {
      emit(CheckingTheFoundData());

      var link = barcode.code;
      if (link != null) {
        var isValid = link.startsWith('https://payflix.page.link/');

        if (isValid) {
          emit(FoundDataIsCorrect());
          var dynamicLink = await _dynamicLinksRepository.instance().getDynamicLink(Uri.parse(link));
          var user = _authRepository.instance().currentUser;

          if (await _validateUser(user)) {
            var uid = user!.uid;
            _addUserToGroup(uid, dynamicLink!.link);
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

  Future _addUserToGroup(String uid, Uri link) async {
    emit(AddingUserToGroup());
    var inviteId = link.queryParametersAll['id']!.first;
    var inviteInfo = await _firestoreRepository.getGroupInviteData(docReference: inviteId);
    var groupId = inviteInfo!.groupId;

    if (await _firestoreRepository.doesUserIsInGroup(docReference: uid, groupId: groupId)) {
      emit(UserIsAlreadyInThisGroup());
    } else if (await _firestoreRepository.doesUserIsInVODGroup(docReference: uid, groupId: groupId)) {
      emit(UserIsAlreadyInThisVodGroup());
    } else {
      await _firestoreRepository.updateUserData(
        docReference: uid,
        data: {
          "groups": FieldValue.arrayUnion([groupId])
        },
      );

      await _firestoreRepository.updateGroupData(
        docReference: groupId,
        data: {
          "users": FieldValue.arrayUnion([uid])
        },
      );

      emit(AddingUserToGroupCompleted());
    }
  }

  @override
  void onChange(Change<QrScannerState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}