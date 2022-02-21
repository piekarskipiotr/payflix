import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class GroupHelper {
  static tryConvertErrorCodeToMessage(BuildContext context, String? errorCode) {
    if (errorCode == null) {
      return null;
    }

    switch (errorCode) {
      case 'user-id-not-found':
        return getString(context).user_id_not_found_error_message;
      default:
        return errorCode;
    }
  }
}
