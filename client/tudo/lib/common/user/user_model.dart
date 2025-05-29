import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  int id;
  String? session;
  String name;
  int gender;
  String phone;
  String avatar;
  @JsonKey(includeFromJson: false, includeToJson: false)
  RxBool? isblock;

  UserModel.empty()
      : id = 0,
        session = '',
        name = '',
        gender = 0,
        phone = '',
        avatar = '',
        isblock = false.obs;

  UserModel(
      {required this.id,
      required this.session,
      required this.name,
      required this.gender,
      required this.phone,
      required this.avatar,
      this.isblock});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
