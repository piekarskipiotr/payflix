import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invite_info.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class InviteInfo {
  @HiveField(0)
  String link;

  @HiveField(1)
  DateTime expiration;

  @HiveField(2)
  @JsonKey(name: 'group_id')
  String groupId;

  InviteInfo(
    this.link,
    this.expiration,
    this.groupId,
  );

  factory InviteInfo.fromJson(Map<String, dynamic> json) =>
      _$InviteInfoFromJson(json);

  Map<String, dynamic> toJson() => _$InviteInfoToJson(this);

  @override
  String toString() => 'InviteInfo{link: $link, expiration: $expiration, groupId: $groupId}';
}
