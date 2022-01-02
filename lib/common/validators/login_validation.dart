import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class LoginValidation {
  static String? validateEmailIdField(BuildContext context, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    // case 2: not matching email pattern
    const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return getString(context).not_email;
    }

    return null;
  }

  static String? validatePasswordField(BuildContext context, String? value) {
    log(value.toString());
    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    return null;
  }
}