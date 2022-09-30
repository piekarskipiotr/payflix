import 'dart:io';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/common/helpers/json_converter_helper.dart';
import 'package:payflix/data/enum/payment_month_status.dart';
import 'package:payflix/screens/group_settings/ui/group_settings.dart';

part 'month_payment_info.g.dart';

@JsonSerializable()
class MonthPaymentInfo {
  final DateTime date;

  @JsonKey(
    fromJson: JsonConverterHelper.getPMSFromCode,
    toJson: JsonConverterHelper.getPMSCode,
  )
  PaymentMonthStatus status;

  MonthPaymentInfo(this.date, this.status);

  String get monthName => DateFormat.MMMM(Platform.localeName.split('_')[0])
      .format(DateTime(date.year, date.month))
      .toCapitalized();

  factory MonthPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$MonthPaymentInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MonthPaymentInfoToJson(this);

  @override
  String toString() => 'MonthPaymentInfo{date: $date, status: $status}';
}
