import 'package:json_annotation/json_annotation.dart';

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

  @JsonKey(ignore: true)
  bool? isCurrentUser;

  PayflixUser(
    this.id,
    this.email,
    this.avatar,
    this.displayName,
    this.groups,
  );

  factory PayflixUser.fromJson(Map<String, dynamic> json) => PayflixUser(
        json['id'] as String,
        json['address_email'] as String,
        Avatar.fromJson(json['avatar']),
        json['display_name'] as String,
        (json['groups'] as List<dynamic>).map((e) => e as String).toList(),
      );

  Map<String, dynamic> toJson() => _$PayflixUserToJson(this);

  @override
  String toString() =>
      'User{id: $id, avatar: $avatar, displayName: $displayName, groups: $groups}';
}
