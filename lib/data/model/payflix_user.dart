import 'package:json_annotation/json_annotation.dart';

part 'payflix_user.g.dart';

@JsonSerializable()
class PayflixUser {
  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'display_name')
  String displayName;

  @JsonKey(name: 'groups')
  List<String> groups;

  PayflixUser(this.id, this.displayName, this.groups);

  factory PayflixUser.fromJson(Map<String, dynamic> json) => _$PayflixUserFromJson(json);

  Map<String, dynamic> toJson() => _$PayflixUserToJson(this);

  @override
  String toString() =>
      'User{id: $id, displayName: $displayName, groups: $groups}';
}
