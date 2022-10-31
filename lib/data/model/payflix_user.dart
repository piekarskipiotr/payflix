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

  @JsonKey(name: 'device_token')
  String deviceToken;

  @JsonKey(ignore: true)
  bool? isCurrentUser;

  PayflixUser(
    this.id,
    this.email,
    this.avatar,
    this.displayName,
    this.groups,
    this.payments,
    this.deviceToken,
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
        json['device_token'] as String,
      );

  Map<String, dynamic> toJson() => _$PayflixUserToJson(this);

  @override
  String toString() =>
      'User{id: $id, avatar: $avatar, displayName: $displayName, groups: $groups, deviceToken: $deviceToken}';
}
