import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/common/helpers/code_painter.dart';
import 'package:payflix/data/app_hive.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/invite_info.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/members/bloc/invite_dialog_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

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
    this._authRepo,
    this._dynamicLinksRepo,
    this._firestoreRepo,
  ) : super(InitInviteDialogState());

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
      } else {
        var link = await _createInviteLink(
          groupType: groupType,
          previousLink: localInviteInfo.link,
        );

        _inviteLink = link;
        linkFieldController.text = link;

        emit(GettingInviteLinkSucceeded());
      }
    } else {
      var uid = _authRepo.getUID();
      var groupId = '${uid}_${groupType.codeName}';

      var group = await _firestoreRepo.getGroupData(docReference: groupId);
      await invitesBox.put(inviteInfoKey, group.inviteInfo);

      getInviteLink(groupType: groupType);
    }
  }

  Future<String> _createAndRemoveExpiredInviteLink(
    String uuid,
    String? previousLink,
  ) async {
    if (previousLink != null) {
      var dynamicLink = await _dynamicLinksRepo
          .instance()
          .getDynamicLink(Uri.parse(previousLink));
      var link = dynamicLink!.link;
      var inviteId = link.queryParametersAll['id']!.first;

      await _firestoreRepo.deleteGroupInviteData(docReference: inviteId);
    }

    return (await _dynamicLinksRepo.createInviteLink(uuid)).toString();
  }

  Future<String> _createInviteLink({
    required GroupType groupType,
    String? previousLink,
  }) async {
    var uid = _authRepo.getUID();
    var uuid = _firestoreRepo.getUUID(collection: groupsInviteCollectionName);
    var expirationDate = DateTime.now().add(const Duration(hours: 1));
    var groupId = '${uid}_${groupType.codeName}';

    var link = await _createAndRemoveExpiredInviteLink(uuid, previousLink);
    var inviteInfo = InviteInfo(
      link,
      expirationDate,
      groupId,
    );

    var json = inviteInfo.toJson();
    await _firestoreRepo.setGroupInviteData(docReference: uuid, data: json);
    await _firestoreRepo.updateGroupInviteData(docReference: uuid, data: json);
    await invitesBox.put(inviteInfoKey, inviteInfo);

    return link;
  }

  Future shareQrCode(String text, String subject) async {
    emit(SharingQrCode());
    await _createAndShareQrCode(text, subject);
    emit(SharingQrCodeFinished());
  }

  Future _writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future _createAndShareQrCode(String text, String subject) async {
    const imageSize = 2048.0;

    try {
      var qrCodeImage = await QrPainter(
        data: linkFieldController.text,
        version: QrVersions.auto,
        color: Colors.black,
        emptyColor: Colors.white,
        gapless: true,
        embeddedImageStyle: null,
        embeddedImage: null,
      ).toImage(imageSize);

      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/payflix_qr_code.png';
      var image = await CodePainter(qrImage: qrCodeImage)
          .toImageData(imageSize, format: ImageByteFormat.png);

      if (image != null) {
        await _writeToFile(image, path);

        await Share.shareFiles(
          [path],
          mimeTypes: ['image/png'],
          text: text,
          subject: subject,
        );
      } else {
        throw 'image-not-created';
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  void onChange(Change<InviteDialogState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
