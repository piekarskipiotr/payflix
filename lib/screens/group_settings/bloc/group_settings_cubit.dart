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
  String? _emailID;
  String? _password;
  bool _isPasswordObscure = true;
  bool _showRegularTitle = false;
  GroupType? _groupType;

  GroupSettingsCubit(
    this._authRepo,
    this._firestoreRepo,
    this._dynamicLinksRepo, this._pickingVodDialogCubit,
  ) : super(InitGroupSettingsState()) {
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
      }

      getVodDialogCubit().pickVod(_groupType!);
    }
  }

  PickingVodDialogCubit getVodDialogCubit() => _pickingVodDialogCubit;

  GroupType getVod() => _groupType!;

  bool isPasswordVisible() => _isPasswordObscure;

  bool showRegularTitle() => _showRegularTitle;

  void handleTitle(double top) {
    if (top < regularTitleTopValue - 5.0 && !showRegularTitle()) {
      emit(ChangingVisibilityOfRegularTitle());
      _showRegularTitle = true;
      emit(VisibilityOfRegularTitleChanged());
    } else if (top > regularTitleTopValue && showRegularTitle()) {
      emit(ChangingVisibilityOfRegularTitle());
      _showRegularTitle = false;
      emit(VisibilityOfRegularTitleChanged());
    }
  }

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

  void setEmailID(String? emailID) => _emailID = emailID;

  void setPassword(String? password) => _password = password;

  Future<void> saveSettings(GroupType groupType) async {
    emit(SavingSettings());
    try {
      var userId = _authRepo.getUID();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupId = _generateGroupId(userId, groupType);
      var groupData = await _generateGroupData(userId);
      await _firestoreRepo.updateGroupData(
          docReference: groupId, data: groupData);

      emit(CreatingGroupSucceeded());
    } catch (e) {
      emit(CreatingGroupFailed(e as String?));
    }
  }

  Future<void> createGroup(GroupType groupType) async {
    emit(CreatingGroup());
    try {
      var userId = _authRepo.getUID();
      if (userId == null) {
        throw 'user-id-not-found';
      }

      var groupId = _generateGroupId(userId, groupType);
      var groupData = await _generateGroupData(userId);

      await _firestoreRepo.setGroupData(docReference: groupId, data: groupData);
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
        emit(CreatingGroupFailed(e as String?));
      }
    }
  }

  Future<InviteInfo> _createInviteLink({required GroupType groupType}) async {
    var uid = _authRepo.getUID();
    var uuid = _firestoreRepo.getUUID(collection: groupsInviteCollectionName);
    var expirationDate = DateTime.now().add(const Duration(days: 7));
    var groupId = '${uid}_${groupType.codeName}';

    var link = (await _dynamicLinksRepo.createInviteLink(uuid)).toString();

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

  Future<Map<String, dynamic>> _generateGroupData(String uid) async {
    var paymentInfo = PaymentInfo(
      monthlyPayment: _monthlyPayment!,
      dayOfTheMonth: _dayOfTheMonth!,
    );

    var accessData = AccessData(
      emailID: _emailID,
      password: _password,
    );

    var inviteInfo = await _createInviteLink(groupType: GroupType.netflix);

    var group = Group(
      paymentInfo: paymentInfo,
      accessData: accessData,
      inviteInfo: inviteInfo,
      users: [uid],
      groupType: GroupType.netflix,
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
