import 'package:get/get.dart';
import 'package:tudo/common/const/root_const.dart';
import 'package:tudo/common/const/user_const.dart';
import 'package:tudo/common/net/http/model/base_net_model.dart';
import 'package:tudo/common/net/meta.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'dart:convert';
import 'package:tudo/common/user/user_model.dart';
import 'package:tudo/common/user/user_net.dart';
import 'package:tudo/pages/login/login_step/login_controller.dart';
import 'package:tudo/pages/root/root_page_controller.dart';
import 'package:tudo/tool/cal_tool.dart';
import 'package:tudo/tool/sp_tool.dart';

class UserManager {
  static final UserManager _instance = UserManager._();
  static UserManager get instance => _instance;
  UserModel? _user;

  UserManager._();

  UserModel? get user => _user;

  String? _refreshToken;

  String? get refreshToken => _refreshToken;

  set refreshToken(String? value) {
    _refreshToken = value;
    SpTool.putString(AppSpKeys.refreshToken, value ?? '');
  }

  int get uid => _user?.id ?? 0;

  bool get isLogin => _user != null && _user!.id != 0 && _user!.session != '';

  String? get token => _user?.session;

  bool get isUserInfoAvailable =>
      _user != null &&
      _user!.id != 0 &&
      _user!.session != '' &&
      _user!.name != '' &&
      _user!.gender != 0;

  updateSingaleInfo({
    int? id,
    String? session,
    String? name,
    int? gender,
    String? avatar,
    String? birth,
    int? height,
    String? description,
    Map<String, dynamic>? infoMap,
  }) {
    if (_user != null) {
      _user!.id = id ?? defaultVlaue(infoMap?[UserInfoKeys.id], _user!.id);
      _user!.session = session ??
          defaultVlaue(infoMap?[UserInfoKeys.session], _user!.session);
      _user!.name =
          name ?? defaultVlaue(infoMap?[UserInfoKeys.name], _user!.name);
      _save();
    }
  }

  init() {
    _load();
  }

  set user(UserModel? value) {
    if (value != null) {
      _update(value);
    }
  }

  void _update(UserModel user) {
    _user = user;
    _save();
  }

  void clear() {
    _user = null;
    SpTool.remove(AppSpKeys.userInfo);
  }

  void toLoginStep() {
    Get.toNamed(RouteConst.login);
  }

  Future<void> toCompleteUserInfo(LoginStep step) async {
    await Get.toNamed(RouteConst.login, arguments: step);
  }

  Future<void> logout() async {
    ToastTool.showLoading();
    await UserNet.logout();
    clear();
    MetaTool.clearMetaData();
    if (Get.isRegistered<RootPageController>()) {
      Get.find<RootPageController>().loginOut();
    }
    ToastTool.closeAllLoading();
    Get.until((route) => route.settings.name == RouteConst.root);
  }

  void _save() {
    SpTool.putString(AppSpKeys.userInfo, jsonEncode(_user?.toJson() ?? {}));
  }

  void _load() {
    String userJson = SpTool.getString(AppSpKeys.userInfo);
    _refreshToken = SpTool.getString(AppSpKeys.refreshToken);
    if (userJson.isNotEmpty) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      if (userMap.isNotEmpty) {
        _user = UserModel.fromJson(userMap);
      }
    }
  }

  Future<void> reNewToken() async {
    BaseNetRes? response = await UserNet.refreshToken();
    if (response != null) {
      _refreshToken = response.data['refresh_token'];
      SpTool.putString(AppSpKeys.refreshToken, _refreshToken ?? '');
      _user?.session = response.data['access_token'];
      MetaTool.fetchMetaMap();
      _save();
    }
  }
}
