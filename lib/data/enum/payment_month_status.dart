import 'package:flutter/material.dart';
import 'package:payflix/resources/colors/app_colors.dart';

enum PaymentMonthStatus {
  paid,
  unpaid,
  future
}

extension PaymentMonthStatusEx on PaymentMonthStatus {
  IconData? get icon {
    switch(this) {
      case PaymentMonthStatus.paid: return Icons.done;
      case PaymentMonthStatus.unpaid: return Icons.priority_high;
      case PaymentMonthStatus.future:return null;
    }
  }

  Color? get bgColor {
    switch(this) {
      case PaymentMonthStatus.paid: return AppColors.green;
      case PaymentMonthStatus.unpaid: return AppColors.red;
      case PaymentMonthStatus.future:return null;
    }
  }
}