import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/joining_group_dialog/bloc/joining_group_dialog_state.dart';

@injectable
class JoiningGroupDialogCubit extends Cubit<JoiningGroupDialogState> {
  final FirestoreRepository _firestoreRepository;

  JoiningGroupDialogCubit(this._firestoreRepository) : super(InitJoiningGroupDialogState());

  Future cancelJoining() async => emit(JoiningToGroupCanceled());

  Future addUserToGroup(String uid, String groupId) async {
    emit(JoiningToGroup());

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

    emit(JoiningToGroupSucceeded());
  }

  @override
  void onChange(Change<JoiningGroupDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}