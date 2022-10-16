import 'package:flutter/material.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

enum PaymentMonthAction { markedAsPaid, markedAsUnpaid, priceModified }

extension PaymentMonthActionEx on PaymentMonthAction {
  String getName(BuildContext context) {
    switch (this) {
      case PaymentMonthAction.markedAsPaid:
        return getString(context).marked_as_paid;
      case PaymentMonthAction.markedAsUnpaid:
        return getString(context).marked_as_unpaid;
      case PaymentMonthAction.priceModified:
        return getString(context).price_modified;
    }
  }
}
