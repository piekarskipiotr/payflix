import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:payflix/common/constants.dart';
import 'package:payflix/data/model/group.dart';
import 'package:payflix/data/model/payflix_user.dart';

@injectable
class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  FirebaseFirestore instance() => _firestore;

  String getUUID({required String collection}) =>
      _firestore.collection(collection).doc().id;

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

  Future<DocumentSnapshot<Map<String, dynamic>>> getGroupInviteData({
    required String docReference,
  }) =>
      _firestore.collection(groupsInviteCollectionName).doc(docReference).get();

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
}
