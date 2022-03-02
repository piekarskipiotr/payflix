import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:payflix/di/get_it.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => $initGetIt(getIt);
