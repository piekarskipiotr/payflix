import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/data/repository/firebase_repository.dart';
import 'package:payflix/screens/verification_room/bloc/ver_room_state.dart';

class VerRoomCubit extends Cubit<VerRoomState> {
  final FirebaseRepository _firebaseRepo;

  Timer? _timer;

  VerRoomCubit(this._firebaseRepo) : super(InitVerRoomState());

  Future<bool> logOut() async {
    emit(LoggingOut());
    await _firebaseRepo.auth().signOut();
    emit(LoggingOutFinished());

    // for onWillPop
    return true;
  }

  Future<void> resendVerificationEmail() async {
    emit(ResendingVerificationEmail());
    try {
      await _firebaseRepo.auth().currentUser!.sendEmailVerification();
      emit(ResendingVerificationEmailSucceeded());
    } on FirebaseAuthException catch (e) {
      emit(ResendingVerificationEmailFailed(e.code));
    } catch (e) {
      emit(ResendingVerificationEmailFailed(e as String?));
    }
  }

  Future<void> listenToVerificationStatus() async {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        await _firebaseRepo.auth().currentUser!.reload();
        var user = _firebaseRepo.auth().currentUser;
        if (user!.emailVerified) {
          timer.cancel();
          emit(EmailVerificationSucceeded());
        }
      } catch (_) {}
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  void onChange(Change<VerRoomState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}
