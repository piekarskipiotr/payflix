import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/data/model/month_payment_info.dart';

import 'avatar.dart';

part 'payflix_user.g.dart';

@JsonSerializable()
class PayflixUser {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'address_email')
  String email;

  @JsonKey(name: 'avatar')
  Avatar avatar;

  @JsonKey(name: 'display_name')
  String displayName;

  @JsonKey(name: 'groups')
  List<String> groups;

  @JsonKey(name: 'payments')
  Map<String, List<MonthPaymentInfo>> payments;

  @JsonKey(name: 'devices_token')
  List<String> devicesToken;

  @JsonKey(ignore: true)
  bool? isCurrentUser;

  PayflixUser(
    this.id,
    this.email,
    this.avatar,
    this.displayName,
    this.groups,
    this.payments,
    this.devicesToken,
  );

  factory PayflixUser.fromJson(Map<String, dynamic> json) => PayflixUser(
        json['id'] as String,
        json['address_email'] as String,
        Avatar.fromJson(json['avatar']),
        json['display_name'] as String,
        (json['groups'] as List<dynamic>).map((e) => e as String).toList(),
        (json['payments'] as Map<String, dynamic>).map(
          (k, e) => MapEntry(
              k,
              (e as List<dynamic>)
                  .map((e) =>
                      MonthPaymentInfo.fromJson(e as Map<String, dynamic>))
                  .toList()),
        ),
        (json['devices_token'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'address_email': email,
        'avatar': avatar.toJson(),
        'display_name': displayName,
        'groups': groups,
        'payments': payments,
        'devices_token': devicesToken,
      };

  @override
  String toString() =>
      'User{id: $id, avatar: $avatar, displayName: $displayName, groups: $groups, devicesToken: $devicesToken}';
}
