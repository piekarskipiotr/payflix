import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/enum/group_type.dart';
import 'package:payflix/data/model/avatar.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/invite_info.dart';
import 'package:payflix/data/model/payflix_user.dart';

@injectable
class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  FirebaseFirestore instance() => _firestore;

  String getUUID({required String collection}) =>
      _firestore.collection(collection).doc().id;

  Future<List<Avatar>> getAvatars() async {
    var avatarsRef = (await _firestore
                .collection(avatarsCollectionName)
                .doc(avatarsCollectionName)
                .get())
            .data();

    if (avatarsRef == null) return [];

    var json = avatarsRef['avatars'] as List;
    return json.map((e) => Avatar.fromJson(e)).toList();
  }

  // group
  Future setGroupData({
    required String docReference,
    required Map<String, dynamic> data,
  }) =>
      _firestore.collection(groupsCollectionName).doc(docReference).set(data);

  Future updateGroupData({
    required String docReference,
    required Map<String, dynamic> data,
  }) =>
      _firestore
          .collection(groupsCollectionName)
          .doc(docReference)
          .update(data);

  Future<Group> getGroupData({
    required String docReference,
  }) async =>
      Group.fromJson((await _firestore
              .collection(groupsCollectionName)
              .doc(docReference)
              .get())
          .data()!);

  Future deleteGroup({
    required String docReference,
  }) async => await _firestore.collection(groupsCollectionName)
      .doc(docReference).delete();

  // group invite
  Future setGroupInviteData({
    required String docReference,
    required Map<String, dynamic> data,
  }) =>
      _firestore
          .collection(groupsInviteCollectionName)
          .doc(docReference)
          .set(data);

  Future updateGroupInviteData({
    required String docReference,
    required Map<String, dynamic> data,
  }) =>
      _firestore
          .collection(groupsInviteCollectionName)
          .doc(docReference)
          .update(data);

  Future<InviteInfo?> getGroupInviteData({
    required String docReference,
  }) async =>
      InviteInfo.fromJson((await _firestore
              .collection(groupsInviteCollectionName)
              .doc(docReference)
              .get())
          .data()!);

  Future deleteGroupInviteData({
    required String docReference,
  }) async => await _firestore.collection(groupsInviteCollectionName)
      .doc(docReference).delete();

  // user
  Future setUserData({
    required String docReference,
    required Map<String, dynamic> data,
  }) =>
      _firestore.collection(usersCollectionName).doc(docReference).set(data);

  Future updateUserData({
    required String docReference,
    required Map<String, dynamic> data,
  }) =>
      _firestore.collection(usersCollectionName).doc(docReference).update(data);

  Future<PayflixUser> getUserData({
    required String docReference,
  }) async =>
      PayflixUser.fromJson((await _firestore
              .collection(usersCollectionName)
              .doc(docReference)
              .get())
          .data()!);

  Future<bool> doesUserExist({
    required String docReference,
  }) async =>
      (await _firestore.collection(usersCollectionName).doc(docReference).get())
          .exists;

  Future<bool> doesUserHasAGroup({
    required String docReference,
  }) async =>
      PayflixUser.fromJson((await _firestore
                  .collection(usersCollectionName)
                  .doc(docReference)
                  .get())
              .data()!)
          .groups
          .isNotEmpty;

  Future<bool> doesUserIsInGroup({
    required String docReference,
    required String groupId,
  }) async =>
      PayflixUser.fromJson((await _firestore
                  .collection(usersCollectionName)
                  .doc(docReference)
                  .get())
              .data()!)
          .groups
          .contains(groupId);

  Future<bool> doesUserIsInVODGroup({
    required String docReference,
    required String groupId,
  }) async {
    var vodGroupType = GroupTypeHelper.getGroupTypeFromGroupId(groupId);
    var groups = PayflixUser.fromJson((await _firestore
        .collection(usersCollectionName)
        .doc(docReference)
        .get())
        .data()!).groups;

    for (var group in groups) {
      var groupType = GroupTypeHelper.getGroupTypeFromGroupId(group);
      if (groupType == vodGroupType) {
        return true;
      }
    }

    return false;
  }

  Future deleteUser({
    required String docReference,
  }) async => await _firestore.collection(usersCollectionName)
      .doc(docReference).delete();

  Future<String> getAdminEmailByGroupId({required groupId}) async {
    var length = groupId.length;
    var userId = groupId.substring(0, length - 6);

    var user = PayflixUser.fromJson((await _firestore
        .collection(usersCollectionName)
        .doc(userId)
        .get())
        .data()!);

    return user.email;
  }

  Future<List<PayflixUser>> getMembers({
    required List<String> ids,
    required String uid,
  }) async {
    var members = List<PayflixUser>.empty(growable: true);
    for (var id in ids) {
      var user = PayflixUser.fromJson(
          (await _firestore.collection(usersCollectionName).doc(id).get())
              .data()!);

      user.isCurrentUser = user.id == uid;
      members.add(user);
    }

    return members;
  }
}
