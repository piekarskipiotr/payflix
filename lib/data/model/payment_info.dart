import 'package:json_annotation/json_annotation.dart';

part 'payment_info.g.dart';

@JsonSerializable()
class PaymentInfo {
  @JsonKey(name: 'monthly_payment')
  double monthlyPayment;

  @JsonKey(name: 'day_of_the_month')
  int dayOfTheMonth;

  PaymentInfo({
    required this.monthlyPayment,
    required this.dayOfTheMonth,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$PaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInfoToJson(this);

  @override
  String toString() =>
      'PaymentInfo{monthlyPayment: $monthlyPayment, dayOfTheMonth: $dayOfTheMonth}';
}
