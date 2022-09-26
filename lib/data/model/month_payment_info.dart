import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/common/helpers/json_converter_helper.dart';
import 'package:payflix/data/enum/payment_month_status.dart';

part 'month_payment_info.g.dart';

@JsonSerializable()
class MonthPaymentInfo {
  final int year;

  final int month;

  @JsonKey(
    fromJson: JsonConverterHelper.getPMSFromCode,
    toJson: JsonConverterHelper.getPMSCode,
  )
  PaymentMonthStatus status;

  MonthPaymentInfo(this.year, this.month, this.status);

  factory MonthPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$MonthPaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MonthPaymentInfoToJson(this);

  @override
  String toString() => 'MonthPaymentInfo{year: $year, month: $month, status: $status}';
}
