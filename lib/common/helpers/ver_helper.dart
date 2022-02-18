import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class VerHelper {
  static tryConvertErrorCodeToMessage(BuildContext context, String? errorCode) {
    if (errorCode == null) {
      return null;
    }

    switch (errorCode) {
      case 'too-many-requests':
        return getString(context).too_many_requests;
      default:
        return errorCode;
    }
  }
}
