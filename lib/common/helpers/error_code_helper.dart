import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class ErrorCodeHelper {
  static tryConvertErrorCodeToMessage(BuildContext context, dynamic errorCode) {
    if (errorCode == null) {
      return null;
    }

    switch (errorCode) {
      case 'user-id-not-found':
        return getString(context).user_id_not_found_error_message;
      case 'user-not-found':
        return getString(context).user_not_found;
      case 'wrong-password':
        return getString(context).wrong_password;
      case 'network-request-failed':
        return getString(context).network_request_failed;
      case 'invalid-email':
        return getString(context).invalid_email;
      case 'weak-password':
        return getString(context).weak_password;
      case 'email-already-in-use':
        return getString(context).email_already_in_use;
      case 'too-many-requests':
        return getString(context).too_many_requests;
      default:
        return errorCode.toString();
    }
  }
}
