import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'uid')
  int id;
  @JsonKey(name: 'access_token')
  String session;
  @JsonKey(name: 'nick_name')
  String name;
  int gender;
  String phone;
  String avatar;
  @JsonKey(name: 'is_active')
  bool isActive;

  UserModel.empty()
      : id = 0,
        session = '',
        name = '',
        gender = 0,
        phone = '',
        avatar = '',
        isActive = false;

  UserModel(
      {required this.id,
      required this.session,
      required this.name,
      required this.gender,
      required this.phone,
      required this.avatar,
      required this.isActive});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
