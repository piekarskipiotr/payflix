import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/data/model/access_data.dart';
import 'package:payflix/data/model/invite_info.dart';
import 'package:payflix/data/model/payment_info.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  @JsonKey(name: 'payment_info')
  PaymentInfo paymentInfo;

  @JsonKey(name: 'access_data')
  AccessData accessData;

  @JsonKey(name: 'invite_info')
  InviteInfo inviteInfo;

  Group({
    required this.paymentInfo,
    required this.accessData,
    required this.inviteInfo,
  });

  @override
  String toString() =>
      'Group{paymentInfo: $paymentInfo, accessData: $accessData, inviteInfo: $inviteInfo}';

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
        accessData: AccessData.fromJson(json["access_data"]),
        inviteInfo: InviteInfo.fromJson(json["invite_info"]),
      );

  Map<String, dynamic> toJson() => {
        "payment_info": paymentInfo.toJson(),
        "access_data": accessData.toJson(),
        "invite_info": inviteInfo.toJson(),
      };
}
