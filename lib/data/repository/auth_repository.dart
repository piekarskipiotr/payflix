import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRepository {
  final _auth = FirebaseAuth.instance;

  FirebaseAuth instance() => _auth;

  String? getUID() => _auth.currentUser?.uid;
}