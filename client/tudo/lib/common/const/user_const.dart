class UserInfoKeys {
  static const String name = 'nick_name';
  static const String phone = 'phone';
  static const String session = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String id = 'uid';
  static const String isblock = 'is_active';
}

class LoginApi {
  static const String loginSendCodeApi = '/api/login/send-sms';
  static const String loginVerifyCodeApi = '/api/login/phone/register';
}

class UserApi {
  static const String setUserProfileApi = '/api/user/profile/update';
  static const String logoutApi = '/api/user/logout';
  static const String refreshTokenApi = '/api/user/refresh/token';
}
