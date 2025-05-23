import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tudo/common/log/td_logger.dart';
import 'package:tudo/common/toast/common_toast.dart';
import 'package:tudo/tool/intl_tool.dart';
import 'package:tudo/tool/string_tool.dart';

/// 系统信息工具类
class SystemInfo {
  static Completer initCompleter = Completer();

  static PackageInfo? packageData;
  static Map<String, dynamic> deviceData = {};

  /// 拷贝文本内容到剪切板
  static bool copyToClipboard(String text, {String? copySuccessText}) {
    if (text.isSafeNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      if (!GetPlatform.isAndroid) {
        ToastTool.show(copySuccessText ?? intlS.copy_success);
      }
      return true;
    }
    return false;
  }

  /// 隐藏软键盘，具体可看：TextInputChannel
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 展示软键盘，具体可看：TextInputChannel
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// 清除数据
  static void clearClientKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.clearClient');
  }

  /// 初始化
  static init() async {
    packageData = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (GetPlatform.isAndroid) {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } else if (GetPlatform.isIOS) {
      deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    }
    // logger.d('deviceInfoPluginData: ${await deviceInfoPlugin.deviceInfo}');
    TdLogger.d('packageData: $packageData');
    TdLogger.d('deviceData: $deviceData');
    if (!initCompleter.isCompleted) {
      initCompleter.complete();
    }
    Future.delayed(const Duration(seconds: 5), () {
      if (!initCompleter.isCompleted) {
        TdLogger.w("SystemTool 初始化超时，兜底完成initCompleter");
        initCompleter.complete();
      }
    });
  }

  static _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'sdk': build.version.sdkInt, // android版本
      'ua': build.display, // 设备显示,暂时用于UA
      'manufacturer': build.manufacturer, // 设备制造商
      'abi': build.supportedAbis, // 支持的CPU架构
      'isPhysicalDevice': build.isPhysicalDevice, // 是否物理设备, 虚拟机为false
      'widthPixels': build.displayMetrics.widthPx.toInt(),
      'inches': build.displayMetrics.widthInches.toInt().round(),
      'heightPixels': build.displayMetrics.heightPx.toInt(),
    };
  }

  static _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
