class UserInfoKeys {
  static const String name = 'nick_name';
  static const String phone = 'phone_num';
  static const String session = 'sid';
  static const String id = 'user_id';
  static const String isblock = 'is_black';
}

class LoginApi {
  static const String loginSendCodeApi = 'send/code';
  static const String loginVerifyCodeApi = 'login/phone/login';
  static const String setUserProfileApi = 'user/profile/update';
  static const String logoutApi = 'user/logout';
}
