import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

enum PaymentMonthStatus { paid, unpaid, expired }

extension PaymentMonthStatusEx on PaymentMonthStatus {
  IconData? get icon {
    switch (this) {
      case PaymentMonthStatus.paid:
        return Icons.done;
      case PaymentMonthStatus.unpaid:
        return null;
      case PaymentMonthStatus.expired:
        return Icons.priority_high;
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
    }
  }
}
