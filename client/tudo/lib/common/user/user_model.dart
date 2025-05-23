import 'package:get/get.dart';

class UserModel {
  int id;
  String? session;
  String name;
  int gender;
  String phone;
  String avatar;
  String frameUrl;
  String birth;
  int height;
  String description;
  RxBool? isblock;

  UserModel.empty()
      : id = 0,
        session = '',
        name = '',
        gender = 0,
        phone = '',
        avatar = '',
        frameUrl = '',
        birth = '',
        height = 0,
        isblock = false.obs,
        description = '';

  UserModel(
      {required this.id,
      required this.session,
      required this.name,
      required this.gender,
      required this.phone,
      required this.avatar,
      required this.frameUrl,
      required this.birth,
      required this.height,
      required this.description,
      this.isblock});
}
