import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflix/screens/group_settings/bloc/group_settings_state.dart';

class GroupSettingsCubit extends Cubit<GroupSettingsState> {
  double? _monthlyPayment;
  int? _dayOfTheMonth;
  String? _emailID;
  String? _password;

  GroupSettingsCubit() : super(InitGroupSettingsState());

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
}
