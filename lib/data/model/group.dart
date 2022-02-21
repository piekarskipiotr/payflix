import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/data/model/access_data.dart';
import 'package:payflix/data/model/payment_info.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  @JsonKey(name: 'payment_info')
  PaymentInfo paymentInfo;

  @JsonKey(name: 'access_data')
  AccessData accessData;

  Group({
    required this.paymentInfo,
    required this.accessData,
  });

  @override
  String toString() =>
      'Group{paymentInfo: $paymentInfo, accessData: $accessData}';

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
    accessData: AccessData.fromJson(json["access_data"]),
  );

  Map<String, dynamic> toJson() => {
    "payment_info": paymentInfo.toJson(),
    "access_data": accessData.toJson(),
  };
}
