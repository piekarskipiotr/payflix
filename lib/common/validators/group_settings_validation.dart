import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class GroupSettingsValidation {
  static String? validatePayment(BuildContext context, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    return null;
  }

  static String? validateDayOfPayment(BuildContext context, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    // case 2: day not in range 1 - 31
    var day = int.tryParse(value);
    if (day != null && (day < 1 || day > 31)) {
      return getString(context).not_in_days_range;
    }

    return null;
  }

  static String? validateEmailIdField(BuildContext context, String? value) {

    if (value == null || value.trim() == '') {
      return null;
    }

    // case 1: not matching email pattern
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return getString(context).not_email;
    }

    return null;
  }
}
