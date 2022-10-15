import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';
import 'package:payflix/resources/l10n/app_localizations_helper.dart';

enum PaymentMonthStatus { paid, unpaid, expired, priceModified}

extension PaymentMonthStatusEx on PaymentMonthStatus {
  String getName(BuildContext context) {
    switch (this) {
      case PaymentMonthStatus.paid:
        return getString(context).paid;
      case PaymentMonthStatus.unpaid:
        return getString(context).unpaid;
      case PaymentMonthStatus.expired:
        return getString(context).expired;
      case PaymentMonthStatus.priceModified:
        return getString(context).price_modified;
    }
  }

  IconData? get icon {
    switch (this) {
      case PaymentMonthStatus.paid:
        return Icons.done;
      case PaymentMonthStatus.unpaid:
        return null;
      case PaymentMonthStatus.expired:
        return Icons.priority_high;
      case PaymentMonthStatus.priceModified:
        return Icons.currency_exchange;
    }
  }

  Color? get bgColor {
    switch (this) {
      case PaymentMonthStatus.paid:
        return AppColors.green;
      case PaymentMonthStatus.unpaid:
        return null;
      case PaymentMonthStatus.expired:
        return AppColors.red;
      case PaymentMonthStatus.priceModified:
        return AppColors.orange;
    }
  }

  String get code {
    switch (this) {
      case PaymentMonthStatus.paid:
        return 'PAID';
      case PaymentMonthStatus.unpaid:
        return 'UNPAID';
      case PaymentMonthStatus.expired:
        return 'EXPIRED';
      case PaymentMonthStatus.priceModified:
        return 'PRICE_MODIFIED';
    }
  }
}
