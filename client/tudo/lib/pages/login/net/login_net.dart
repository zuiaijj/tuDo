import 'package:tudo/common/const/user_const.dart';
import 'package:tudo/common/net/http/api/api.dart';
import 'package:tudo/common/net/http/model/base_net_model.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'package:tudo/common/user/user_model.dart';
import 'package:tudo/tool/encrypt_tool.dart';

class LoginNet {
  static Map<String, dynamic> assembleSendCodeReq(
      String phone, String areaCode) {
    final prefix = areaCode.replaceAll('+', '').replaceAll('+', '');
    String encodeAreaCode = prefix;
    if (!phone.startsWith(prefix) && areaCode != "") {
      phone = prefix + phone;
    }
    return {
      'phone': EncryptTool.rsaPhoneEncrypt(phone),
      'dial_code': encodeAreaCode,
    };
  }

  static Future<BaseNetRes?> sendCode(String phone, String areaCode) async {
    BaseNetRes response = await Api.ins.post(
      LoginApi.loginSendCodeApi,
      body: assembleSendCodeReq(phone, areaCode),
    );
    if (response.isSuccess) {
      return response;
    }
    ToastTool.show(response.message);
    return null;
  }

  static Map<String, dynamic> assembleLoginVerifyCodeReq(String phone,
      String code, String areaCode, String requestId, String countryCode) {
    Map<String, dynamic> req = assembleSendCodeReq(phone, areaCode);
    req['sms_code'] = code;
    req['code_id'] = requestId;
    return req;
  }

  static Future<(UserModel?, String?)> loginVerifyCode(
      String phone,
      String code,
      String areaCode,
      String requestId,
      String countryCode) async {
    BaseNetRes response = await Api.ins.post(
      LoginApi.loginVerifyCodeApi,
      body: assembleLoginVerifyCodeReq(
          phone, code, areaCode, requestId, countryCode),
    );
    if (response.isSuccess) {
      return (
        UserModel.fromJson(response.data["user"]),
        response.data["refresh_token"]?.toString()
      );
    }
    ToastTool.show(response.message);
    return (null, null);
  }

  static Future<bool> setProfile(Map<String, dynamic> params) async {
    BaseNetRes response = await Api.ins.post(
      LoginApi.setUserProfileApi,
      body: params,
      forceFetch: true,
    );
    if (response.isSuccess) {
      return true;
    }
    ToastTool.show(response.message);
    return false;
  }

  static logout() async {
    await Api.ins.post(
      LoginApi.logoutApi,
    );
  }
}
