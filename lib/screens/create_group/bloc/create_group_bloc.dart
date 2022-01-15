import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/create_group/bloc/create_group_state.dart';

class CreateGroupBloc extends Cubit<CreateGroupState> {
  CreateGroupBloc() : super(InitCreateGroupState());


  @override
  void onChange(Change<CreateGroupState> change) {
    super.onChange(change);
    log(change.toString(), name: runtimeType.toString());
  }
}