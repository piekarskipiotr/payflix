import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/welcome/bloc/welcome_state.dart';

@injectable
class WelcomeCubit extends Cubit<WelcomeState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepository;

  WelcomeCubit(this._authRepo, this._firestoreRepository) : super(InitWelcomeState());

  Future isAlreadyInGroup() async {
    var uid = _authRepo.getUID();
    var user = await _firestoreRepository.getUserData(docReference: uid!);
    if (user.groups.isNotEmpty) {
      emit(NavigateToGroup());
    }
  }

  @override
  void onChange(Change<WelcomeState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
