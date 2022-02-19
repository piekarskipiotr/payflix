import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';

class GroupSettingsCubit extends Cubit<GroupSettingsState> {
  GroupSettingsCubit() : super(InitGroupSettingsState());

}