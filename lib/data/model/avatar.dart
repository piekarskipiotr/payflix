import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/common/helpers/color_converter.dart';

part 'avatar.g.dart';

@JsonSerializable()
class Avatar {
  String url;
  @JsonKey(
      fromJson: ColorConverter.fromIntToColor,
      toJson: ColorConverter.fromColorToInt)
  Color background;

  Avatar(this.url, this.background);

  @override
  String toString() => 'Avatar{url: $url, background: $background}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Avatar &&
          url == other.url &&
          background == other.background;

  @override
  int get hashCode => url.hashCode ^ background.hashCode;

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);

  Map<String, dynamic> toJson() => _$AvatarToJson(this);
}
