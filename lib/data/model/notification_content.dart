import 'package:json_annotation/json_annotation.dart';

part 'notification_content.g.dart';

@JsonSerializable()
class NotificationContent {
  final String title;
  final String body;

  NotificationContent(this.title, this.body);

  @override
  String toString() => 'NotificationContent{title: $title, body: $body}';

  factory NotificationContent.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationContentToJson(this);
}
