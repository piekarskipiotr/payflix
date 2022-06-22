import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class EditProfileValidation {
  static String? validateDisplayName(BuildContext context, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    return null;
  }
}