import 'package:json_annotation/json_annotation.dart';

part 'payment_info.g.dart';

@JsonSerializable()
class PaymentInfo {
  @JsonKey(name: 'monthly_payment')
  double monthlyPayment;

  @JsonKey(name: 'day_of_the_month')
  int dayOfTheMonth;

  @JsonKey(name: 'bank_account_number')
  String? bankAccountNumber;

  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  PaymentInfo({
    required this.monthlyPayment,
    required this.dayOfTheMonth,
    this.bankAccountNumber,
    this.phoneNumber,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInfoToJson(this);

  @override
  String toString() =>
      'PaymentInfo{monthlyPayment: $monthlyPayment, dayOfTheMonth: $dayOfTheMonth, bankAccountNumber: $bankAccountNumber, phoneNumber: $phoneNumber}';
}
