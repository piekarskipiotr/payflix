import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/data/enum/payment_month_action.dart';

part 'month_payment_history.g.dart';

@JsonSerializable()
class MonthPaymentHistory {
  DateTime date;
  PaymentMonthAction action;

  MonthPaymentHistory(this.date, this.action);

  factory MonthPaymentHistory.fromJson(Map<String, dynamic> json) =>
      _$MonthPaymentHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$MonthPaymentHistoryToJson(this);

  @override
  String toString() => 'MonthPaymentHistory{date: $date, action: $action}';
}