import 'package:get/get.dart';
import 'package:tudo/common/const/root_const.dart';
import 'package:tudo/common/net/meta.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'dart:convert';
import 'package:tudo/common/user/user_model.dart';
import 'package:tudo/pages/root/root_page_controller.dart';
import 'package:tudo/tool/sp_tool.dart';

class UserManager {
  static final UserManager _instance = UserManager._();
  static UserManager get instance => _instance;
  UserModel? _user;

  UserManager._();

  UserModel? get user => _user;

  int get uid => _user?.id ?? 0;

  bool get isLogin => _user != null && _user!.id != 0 && _user!.session != '';

  String? get token => _user?.session;

  bool get isUserInfoAvailable =>
      _user != null &&
      _user!.id != 0 &&
      _user!.session != '' &&
      _user!.name != '' &&
      _user!.gender != 0;

  init() {
    _load();
  }

  void clear() {
    _user = null;
    SpTool.remove(AppSpKeys.userInfo);
  }

  Future<void> logout() async {
    ToastTool.showLoading();
    // await LoginNet.logout();
    clear();
    MetaTool.clearMetaData();
    if (Get.isRegistered<RootPageController>()) {
      Get.find<RootPageController>().loginOut();
    }
    ToastTool.closeAllLoading();
    Get.until((route) => route.settings.name == RouteConst.root);
  }

  void _save() {
    // SpTool.putString(AppSpKeys.userInfo, jsonEncode(_user?.toJson() ?? {}));
  }

  void _load() {
    String userJson = SpTool.getString(AppSpKeys.userInfo);
    if (userJson.isNotEmpty) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      if (userMap.isNotEmpty) {
        // _user = UserModel.fromJson(userMap);
      }
    }
  }
}
