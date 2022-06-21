import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

class ChangePasswordValidation {
  static String? validatePasswordField(BuildContext context, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    return null;
  }

  static String? validateNewPasswordField(BuildContext context, String? previousPassword, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    // case 2: Password same as previous
    if (previousPassword?.trim() == value.trim()) {
      return getString(context).password_cannot_be_same_as_previous;
    }

    return null;
  }

  static String? validateConfirmPasswordField(BuildContext context, String? newPassword, String? value) {

    // case 1: Empty field
    if (value == null || value.trim() == '') {
      return getString(context).field_cannot_be_empty;
    }

    // case 2: Passwords not the same
    if (newPassword?.trim() != value.trim()) {
      return getString(context).passwords_not_the_same;
    }

    return null;
  }
}