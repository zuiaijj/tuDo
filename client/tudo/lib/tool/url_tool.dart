import 'dart:async';
import 'package:tudo/common/const/app_const.dart';
import 'package:tudo/common/net/meta.dart';
import 'package:tudo/tool/string_tool.dart';

class UrlTool {
  /// 获取url链接中host
  static String? getUrlHost(String url) {
    if (url.isSafeEmpty) {
      return null;
    }
    String? host;
    try {
      host = Uri.parse(url).host;
    } catch (e) {
      host = null;
    }
    return host;
  }

  // /// 获取userAgent
  // static String getUserAgent() {
  //   if (System.deviceData.isEmpty) return '';
  //   return System.deviceData['ua'] ?? '';
  // }

  /// 获取url链接中scheme
  static String? getUrlScheme(String url) {
    if (url.isSafeEmpty) {
      return null;
    }
    String? host;
    try {
      host = Uri.parse(url).scheme;
    } catch (e) {
      host = null;
    }
    return host;
  }

  /// 判断url链接是否包含参数
  static bool containsTarget(String url, String target) {
    if (url.isSafeNotEmpty) {
      Uri uri = Uri.parse(url);
      for (int i = 0; i < uri.pathSegments.length; i++) {
        if (uri.pathSegments[i] == target) {
          return true;
        }
      }
    }
    return false;
  }

  /// 获取url中第一个参数
  static String? getFirstPath(String url) {
    if (url.isEmpty) {
      return null;
    }
    Uri? uri = Uri.tryParse(url);
    if (uri == null) {
      return null;
    }
    if (uri.queryParameters.isNotEmpty) {
      uri = uri.replace(queryParameters: {});
    }
    return uri.pathSegments[0];
  }

  /// url拼接meta参数
  static Future<String> urlWithMeta(String url,
      {bool forceFetch = false}) async {
    if (url.isSafeEmpty) return '';
    String metaParams = await MetaTool.getMetaUrl(forceFetch: forceFetch);
    return urlJoint(url, metaParams);
  }

  /// url参数拼接
  static String urlJoint(String url, String param) {
    if (url.isSafeEmpty) return '';
    String hash = '';
    if (url.contains('#')) {
      List<String> list = url.split('#');
      url = list.first;
      hash = '#${list.last}';
    }

    String symbol = '?';
    if (url.contains('?')) symbol = '&';
    return '$url$symbol$param$hash';
  }

  /// 判断是否业务scheme
  static bool isAppScheme(String scheme) =>
      scheme.isSafeNotEmpty &&
      ((AppConst.jumpScheme.contains(scheme)) ||
          (AppConst.jumpScheme.any((element) => scheme.startsWith(element))));

  /// 判断是否http地址
  static bool isHttpScheme(String uri) =>
      uri.isSafeNotEmpty && uri.startsWith("http");

  static bool isUrlGooglePlay(String currentScheme) {
    return currentScheme.contains("play.google.com");
  }

  /// 短链接肯定不带？
  static bool isShortUrl(String currentScheme) {
    if (currentScheme.contains("?")) {
      return false;
    }
    return true;
  }

  /// 在应用内打开页面
  // static FutureOr<void> launchURL(
  //   BuildContext context,
  //   String url, {
  //   bool needMeta = true,
  //   bool halfScreen = false,
  //   bool needNavBar = false,
  //   Widget? loadingWidget,
  //   final bool showWebLoading = true,
  //   final Color webBgColor = Colors.white,
  //   Function(String url)? onPageFinished,
  //   Function? backHandler,
  // }) async {
  //   String? path;
  //   try {
  //     Uri? uri = Uri.tryParse(url);
  //     path = uri?.path;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //     }
  //   }
  //   // 自定义webview
  //   if (needMeta) url = await UrlTool.urlWithMeta(url);
  //   if (halfScreen == true) {
  //     // await showCupertinoModalPopup<void>(
  //     //     context: Get.context!,
  //     //     useRootNavigator: true,
  //     //     routeSettings: RouteSettings(name: "half/WebView/$path"),
  //     //     builder: (BuildContext context) {
  //     //       return Web(
  //     //         context: Get.context!,
  //     //         url: url,
  //     //         halfScreen: halfScreen,
  //     //         needNavBar: needNavBar,
  //     //         loadingWidget: loadingWidget,
  //     //         showWebLoading: showWebLoading,
  //     //         webBgColor: webBgColor,
  //     //         onPageFinished: onPageFinished,
  //     //       );
  //     //     }).then((value) {
  //     //   backHandler?.call();
  //     // });
  //   } else {
  //     // await Navigator.push(
  //     //         Get.context!,
  //     //         PageRouteBuilder(
  //     //             opaque: false,
  //     //             pageBuilder: (context, animation, secondaryAnimation) {
  //     //               return Web(
  //     //                   context: Get.context!,
  //     //                   url: url,
  //     //                   needNavBar: needNavBar,
  //     //                   showWebLoading: showWebLoading,
  //     //                   loadingWidget: loadingWidget,
  //     //                   webBgColor: webBgColor,
  //     //                   onPageFinished: onPageFinished);
  //     //             },
  //     //             settings: RouteSettings(name: "full/WebView/$path")))
  //     //     .then((value) {
  //     //   backHandler?.call();
  //     // });
  //   }
  // }
}
