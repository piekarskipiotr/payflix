import 'package:payflix/data/enum/payment_month_status.dart';

class JsonConverterHelper {
  static PaymentMonthStatus getPMSFromCode(String code) {
    switch (code) {
      case 'PAID':
        return PaymentMonthStatus.paid;
      case 'UNPAID':
        return PaymentMonthStatus.unpaid;
      case 'EXPIRED':
        return PaymentMonthStatus.expired;
      default:
        return PaymentMonthStatus.unpaid;
    }
  }

  static String getPMSCode(PaymentMonthStatus pms) => pms.code;
}
