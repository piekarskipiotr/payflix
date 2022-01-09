import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class LoginHelper {
  static tryConvertErrorCodeToMessage(BuildContext context, String? errorCode) {
    if (errorCode == null) {
      return null;
    }

    switch (errorCode) {
      case 'user-not-found':
        return getString(context).user_not_found;
      case 'wrong-password':
        return getString(context).wrong_password;
      default:
        return errorCode;
    }
  }
}