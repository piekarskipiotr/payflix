import 'package:json_annotation/json_annotation.dart';
import 'package:payflix/data/model/notification_content.dart';
import 'package:payflix/data/model/notification_data.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  @JsonKey(name: 'notification')
  final NotificationContent content;

  @JsonKey(name: 'priority')
  final String priority;

  @JsonKey(name: 'data')
  final NotificationData data;

  @JsonKey(name: 'to')
  final String destinationToken;

  Notification(this.content, this.priority, this.data, this.destinationToken);

  @override
  String toString() => 'Notification{content: $content, priority: $priority, data: $data, destinationToken: $destinationToken}';

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}