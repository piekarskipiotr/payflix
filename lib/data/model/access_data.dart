import 'package:json_annotation/json_annotation.dart';

part 'access_data.g.dart';

@JsonSerializable()
class AccessData {
  @JsonKey(name: 'email_id')
  String? emailID;

  @JsonKey(name: 'password')
  String? password;

  AccessData({
    required this.emailID,
    required this.password,
  });

  bool isDataEmpty() => isEmailIDEmpty() && isPasswordEmpty();

  bool isEmailIDEmpty() => emailID == null || emailID?.trim() == '';

  bool isPasswordEmpty() => password == null || password?.trim() == '';

  @override
  String toString() => 'AccessData{emailID: $emailID, password: $password}';

  factory AccessData.fromJson(Map<String, dynamic> json) =>
      _$AccessDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccessDataToJson(this);
}
