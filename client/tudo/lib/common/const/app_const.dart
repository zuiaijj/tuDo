import 'dart:io';

class AppConst {
  static const String appName = 'TuDo';
  static const List<String> jumpScheme = ['td', 'td-dev', 'td-test', 'td-prod'];
  static const String bunldId = 'com.example.tudo';

  static String get appUrl {
    if (Platform.isIOS) {
      return AppServerConfig.appleStoreUrl;
    }
    return AppServerConfig.googlePlayUrl;
  }
}

class AppServerConfig {
  static const String img = '';

  static const String serviceApi = '';

  static const String testServiceApi = '';

  // 隐私协议
  static const String privacy = '';

  // 服务协议
  static const String service = '';

  // 儿童安全
  static const String child = '';

  // 图片缩放服务
  /// 缩放服务域名(正式/测试环境) 缩放服务没有测试环境
  static const String ONLINE_SCALE_IMG_URL = "";

  /// 占位头像
  static const String DEFAULT_AVATAR = "";

  ///token方式上传
  static const String UPLOAD_TOKEN = "";

  ///文件上传接
  static const String MEDIA_UPLOAD = "";

  static const String googlePlayUrl = "";
  static const String appleStoreUrl = "";
}
