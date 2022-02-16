import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

//global var
final getIt = GetIt.instance;
void initializeDependencies() {
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}