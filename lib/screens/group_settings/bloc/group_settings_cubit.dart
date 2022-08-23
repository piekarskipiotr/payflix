import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/app_hive.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/access_data.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/invite_info.dart';
import 'package:payflix/data/model/payment_info.dart';
import 'package:payflix/data/repository/auth_repository.dart';
import 'package:payflix/data/repository/dynamic_links_repository.dart';
import 'package:payflix/data/repository/firestore_repository.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';
import 'package:payflix/screens/members/bloc/members_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_cubit.dart';
import 'package:payflix/screens/picking_vod_dialog/bloc/picking_vod_dialog_state.dart';

@injectable
class GroupSettingsCubit extends Cubit<GroupSettingsState> {
  final AuthRepository _authRepo;
  final FirestoreRepository _firestoreRepo;
  final DynamicLinksRepository _dynamicLinksRepo;
  final PickingVodDialogCubit _pickingVodDialogCubit;
  late StreamSubscription _pickingVodDialogCubitSubscription;

  double? _monthlyPayment;
  int? _dayOfTheMonth;
  String? _bankAccountNo;
  String? _phoneNumber;
  String? _emailID;
  String? _password;
  bool _isPasswordObscure = true;
  GroupType? _groupType;

  GroupSettingsCubit(
    this._authRepo,
    this._firestoreRepo,
    this._dynamicLinksRepo,
    this._pickingVodDialogCubit,
  ) : super(InitGroupSettingsState()) {
    getGroups();
    _pickingVodDialogCubitSubscription = _pickingVodDialogCubit.stream.listen(
      (state) {
        if (state is VodPicked) {
          emit(ChangingVod());
          var vod = state.groupType;
          _groupType = vod;
          emit(VodChanged());
        }
      },
    );
  }

  void initializeVod(dynamic arg) {
    if (_groupType == null) {
      if (arg is GroupType) {
        _groupType = arg;
      } else if (arg is Group) {
        _groupType = arg.groupType;
      } else {
        _groupType = GroupType.netflix;
      }

      getVodDialogCubit().pickVod(_groupType!);
    }
  }

  Future getGroups() async {
    var user = _authRepo.instance().currentUser;
    var groups = List<Group>.empty(growable: true);

    if (user != null) {
      var uid = user.uid;
      var userData = await _firestoreRepo.getUserData(docReference: uid);
      var userGroups = userData.groups;

      for (var id in userGroups) {
        var groupData = await _firestoreRepo.getGroupData(docReference: id);
        groups.add(groupData);
      }

      getVodDialogCubit().setUserGroup(groups);
    }
  }

  PickingVodDialogCubit getVodDialogCubit() => _pickingVodDialogCubit;

  GroupType getVod() => _groupType!;

  bool isPasswordVisible() => _isPasswordObscure;

  void changePasswordVisibility() {
    emit(ChangingPasswordVisibility());
    _isPasswordObscure = !_isPasswordObscure;
    emit(PasswordVisibilityChanged());
  }

  void setMonthlyPayment(String? monthlyPayment) {
    if (monthlyPayment != null) {
      _monthlyPayment = double.tryParse(monthlyPayment);
    } else {
      _monthlyPayment = null;
    }
  }

  void setDayOfTheMonth(String? dayOfTheMonth) {
    if (dayOfTheMonth != null) {
      _dayOfTheMonth = int.tryParse(dayOfTheMonth);
    } else {
      _dayOfTheMonth = null;
    }
  }

  void setBankAccountNumber(String? bankAccountNo) =>
      _bankAccountNo = bankAccountNo;

  void setPhoneNumber(String? phoneNumber) => _phoneNumber = phoneNumber;

  void setEmailID(String? emailID) => _emailID = emailID;

  void setPassword(String? password) => _password = password;

  Future<void> saveSettings(Group? group, MembersCubit? membersCubit) async {
    emit(SavingSettings());
    try {
      var userId = _authRepo.getUID();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      GroupType groupType = getVod();
      var groupId = _generateGroupId(userId, groupType);
      var groupData = await _generateGroupData(
        userId,
        groupType,
        group?.inviteInfo,
      );

      if (group != null) {
        group = Group.fromJson(groupData);
        membersCubit?.updateGroup(group);
      }

      await _firestoreRepo.updateGroupData(
        docReference: groupId,
        data: groupData,
      );

      emit(SavingSettingsSucceeded());
    } catch (e) {
      emit(CreatingGroupFailed(e));
    }
  }

  Future<void> createGroup() async {
    emit(CreatingGroup());
    try {
      var userId = _authRepo.getUID();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupType = getVod();
      var groupId = _generateGroupId(userId, groupType);
      var groupData = await _generateGroupData(
        userId,
        groupType,
        null,
      );

      await _firestoreRepo.setGroupData(
        docReference: groupId,
        data: groupData,
      );

      await _firestoreRepo.updateUserData(
        docReference: userId,
        data: {
          "groups": FieldValue.arrayUnion([groupId])
        },
      );

      emit(CreatingGroupSucceeded());
    } catch (e) {
      if (e is FirebaseException) {
        emit(CreatingGroupFailed(e.message));
      } else {
        emit(CreatingGroupFailed(e));
      }
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

  Future<InviteInfo> _createInviteLink({
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
    return inviteInfo;
  }

  String _generateGroupId(String userId, GroupType groupType) =>
      '${userId}_${groupType.codeName}';

  Future<Map<String, dynamic>> _generateGroupData(
    String uid,
    GroupType groupType,
    InviteInfo? inviteInfo,
  ) async {
    var paymentInfo = PaymentInfo(
      monthlyPayment: _monthlyPayment!,
      dayOfTheMonth: _dayOfTheMonth!,
      bankAccountNumber: _bankAccountNo,
      phoneNumber: _phoneNumber,
    );

    var accessData = AccessData(
      emailID: _emailID,
      password: _password,
    );

    inviteInfo ??= await _createInviteLink(
      groupType: groupType,
      previousLink: inviteInfo?.link,
    );

    var group = Group(
      paymentInfo: paymentInfo,
      accessData: accessData,
      inviteInfo: inviteInfo,
      users: [uid],
      groupType: groupType,
    );

    return group.toJson();
  }

  @override
  Future<void> close() async {
    await _pickingVodDialogCubitSubscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<GroupSettingsState> change) {
    log('$change', name: '$runtimeType');
    super.onChange(change);
  }
}
