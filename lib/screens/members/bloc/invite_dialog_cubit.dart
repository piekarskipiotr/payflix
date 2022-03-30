import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/app_hive.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/invite_info.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_state.dart';

@injectable
class InviteDialogCubit extends Cubit<InviteDialogState> {
  final AuthRepository _authRepo;
  final DynamicLinksRepository _dynamicLinksRepo;
  final FirestoreRepository _firestoreRepo;
  final TextEditingController linkFieldController = TextEditingController();
  bool _showSecondary = false;
  bool _showCopiedText = false;
  String? _inviteLink;

  InviteDialogCubit(
      this._authRepo, this._dynamicLinksRepo, this._firestoreRepo)
      : super(InitInviteDialogState());

  bool showSecondary() => _showSecondary;

  bool showCopiedText() => _showCopiedText;

  void changeView() {
    emit(ChangingDialogView());
    _showSecondary = !_showSecondary;
    emit(DialogViewChanged());
  }

  Future<void> copyInviteLink() async {
    if (_inviteLink != null) {
      emit(ChangingCopiedTextVisibility());
      Clipboard.setData(
        ClipboardData(
          text: _inviteLink,
        ),
      );

      // show 'copied' text below field
      _showCopiedText = !_showCopiedText;
      emit(CopiedTextVisibilityChanged());

      // hide it after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      emit(ChangingCopiedTextVisibility());
      _showCopiedText = !_showCopiedText;
      emit(CopiedTextVisibilityChanged());
    }
  }

  Future getInviteLink({required GroupType groupType}) async {
    emit(GettingInviteLink());
    InviteInfo? localInviteInfo = invitesBox.get(
      inviteInfoKey,
      defaultValue: null,
    );

    if (localInviteInfo != null) {
      var now = DateTime.now();

      if (localInviteInfo.expiration.isAfter(now)) {
        var link = localInviteInfo.link;

        _inviteLink = link;
        linkFieldController.text = link;
        emit(GettingInviteLinkSucceeded());

        return;
      } else {
        _createInviteLink(groupType: groupType);
      }
    } else {
      var uid = _authRepo.getUID();
      var groupId = '${uid}_${GroupType.netflix.codeName}';

      var group = await _firestoreRepo.getGroupData(docReference: groupId);
      await invitesBox.put(inviteInfoKey, group.inviteInfo);

      getInviteLink(groupType: groupType);
    }
  }

  Future<void> _createInviteLink({required GroupType groupType}) async {
    var uid = _authRepo.getUID();
    var uuid = _firestoreRepo.getUUID(collection: groupsInviteCollectionName);
    var expirationDate = DateTime.now().add(const Duration(days: 7));
    var groupId = '$uid${groupType.codeName}';

    var link =
    (await _dynamicLinksRepo.createInviteLink(uuid))
        .toString();

    var inviteInfo = InviteInfo(
      link,
      expirationDate,
      groupId,
    );

    var json = inviteInfo.toJson();
    await _firestoreRepo.setGroupInviteData(docReference: uuid, data: json);
    await invitesBox.put(inviteInfoKey, inviteInfo);
  }

  @override
  void onChange(Change<InviteDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
