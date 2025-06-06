import 'package:tudo/common/const/user_const.dart';
import 'package:tudo/common/net/http/api/api.dart';
import 'package:tudo/common/net/http/model/base_net_model.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'package:tudo/common/user/user_manager.dart';

class UserNet {
  static Future<bool> setProfile(Map<String, dynamic> params) async {
    BaseNetRes response = await Api.ins.post(
      UserApi.setUserProfileApi,
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
      UserApi.logoutApi,
    );
  }

  static Future<BaseNetRes?> refreshToken() async {
    BaseNetRes response = await Api.ins.post(
      UserApi.refreshTokenApi,
      body: {
        "refresh_token": UserManager.instance.refreshToken,
      },
    );
    if (response.isSuccess) {
      return response;
    }
    ToastTool.show(response.message);
    return null;
  }
}
