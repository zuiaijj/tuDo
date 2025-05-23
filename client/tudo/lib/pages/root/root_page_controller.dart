import 'package:get/get.dart';
import 'package:tudo/common/env/env_manager.dart';
import 'package:tudo/common/net/http/api/api.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'package:tudo/common/user/user_manager.dart';
import 'package:tudo/tool/file_tool.dart';
import 'package:tudo/tool/sp_tool.dart';
import 'package:tudo/tool/system.dart';

import '../../common/const/root_const.dart';

class RootPageController extends GetxController {
  /// 是否已登录
  final RxBool _isLoggedIn = false.obs;

  bool get isLoggedIn => _isLoggedIn.value;

  /// 是否正在加载
  final RxBool _isLoading = true.obs;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  _init() async {
    await initBeforeAgree();
    UserManager.instance.init();
    _checkIfCanEnterHall();
  }

  _checkIfCanEnterHall() async {
    // 如果用户已经登录，则初始化内容
    if (UserManager.instance.isLogin) {
      await initAfterAgree();
      await initAfterLogin();
    }
    _isLoading.value = false;
    update();
  }

  loginOut() {
    _isLoggedIn.value = false;
    _isLoading.value = false;
    update();
  }

  Future<void> initBeforeAgree() async {
    // 初始化SP
    await initAppOnce(SpTool.init, InitAppTag.initSp);
    // 初始化环境
    await initAppOnce(EnvManager.init, InitAppTag.initEnv);
    // 初始化dio， 不会发出请求
    initAppOnce(Api.ins.init, InitAppTag.initApi);
    // 初始化loading
    initAppOnce(ToastTool.configToast, InitAppTag.initLoading);
  }

  Future<void> initAfterAgree() async {
    // 登陆前初始化内容, 获取系统信息
    await initAppOnce(SystemInfo.init, InitAppTag.initSystemInfo);
    // 初始化文件工具
    await initAppOnce(FileTool.init, InitAppTag.initFileTool);
  }

  Future<void> initAfterLogin() async {
    // 登陆后初始化内容
    _isLoggedIn.value = true;
    _isLoading.value = false;
    update();
  }

  Future<void> initEnterHall() async {
    if (EnvManager.isOnline) {
      /// 线上环境初始化内容
    }
    // 进入大厅后初始化内容
    // 处理业务进入大厅的初始化内容
  }
}

Map<String, bool> initOnceTag = {};

Future<void> initAppOnce(Function onInit, String tag) async {
  if (initOnceTag.containsKey(tag)) return;
  initOnceTag[tag] = true;
  // 初始化app一次
  await onInit();
}
