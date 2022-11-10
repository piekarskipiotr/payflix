import 'package:json_annotation/json_annotation.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData {
  final String id;
  final String action;
  final String status;

  NotificationData({
    required this.id,
    required this.action,
    required this.status,
  });

  @override
  String toString() =>
      'NotificationData{id: $id, action: $action, status: $status}';

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
