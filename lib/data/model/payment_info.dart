import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment_info.g.dart';

@JsonSerializable()
class PaymentInfo {
  @JsonKey(name: 'monthly_payment')
  double monthlyPayment;

  @JsonKey(name: 'currency')
  String currency;

  @JsonKey(name: 'day_of_the_month')
  int dayOfTheMonth;

  @JsonKey(name: 'bank_account_number')
  String? bankAccountNumber;

  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  PaymentInfo({
    required this.monthlyPayment,
    required this.currency,
    required this.dayOfTheMonth,
    this.bankAccountNumber,
    this.phoneNumber,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInfoToJson(this);

  bool isOptionalDataEmpty() =>
      isBankAccountNumberEmpty() && isPhoneNumberEmpty();

  bool isBankAccountNumberEmpty() =>
      bankAccountNumber == null || bankAccountNumber?.trim() == '';

  bool isPhoneNumberEmpty() => phoneNumber == null || phoneNumber?.trim() == '';

  DateTime getNextDate({DateTime? fromDate}) {
    var now = clock.now();
    var today = fromDate ?? DateTime(now.year, now.month, now.day);
    var days = _daysInMonth(today);

    DateTime nextDate;
    if (days < dayOfTheMonth) {
      nextDate = DateTime(today.year, today.month, days);
    } else {
      nextDate = DateTime(today.year, today.month, dayOfTheMonth);
      if (nextDate.isBefore(today)) {
        nextDate = DateTime(today.year, today.month + 1, dayOfTheMonth);
      }
    }

    return nextDate;
  }

  int getDaysUntilNextPayment({DateTime? fromDate}) {
    var now = clock.now();
    var today = DateTime(now.year, now.month, now.day);
    return getNextDate(fromDate: fromDate).difference(today).inDays;
  }

  int _daysInMonth(DateTime date) => DateTimeRange(
        start: DateTime(date.year, date.month, 1),
        end: DateTime(date.year, date.month + 1),
      ).duration.inDays;

  @override
  String toString() =>
      'PaymentInfo{monthlyPayment: $monthlyPayment, dayOfTheMonth: $dayOfTheMonth, bankAccountNumber: $bankAccountNumber, phoneNumber: $phoneNumber}';
}
