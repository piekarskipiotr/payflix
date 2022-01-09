import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class RegistrationHelper {
  static tryConvertErrorCodeToMessage(BuildContext context, String? errorCode) {
    if (errorCode == null) {
      return null;
    }

    switch (errorCode) {
      case 'network-request-failed':
        return getString(context).network_request_failed;
      case 'invalid-email':
        return getString(context).invalid_email;
      case 'weak-password':
        return getString(context).weak_password;
      case 'email-already-in-use':
        return getString(context).email_already_in_use;
    }
  }
}
