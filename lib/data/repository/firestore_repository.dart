import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  FirebaseFirestore instance() => _firestore;

  String getUUID({required String collection}) =>
      _firestore.collection(collection).doc().id;
}
