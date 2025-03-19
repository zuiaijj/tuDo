import 'dart:io';
import 'package:flutter/foundation.dart';

/// 平台特定功能工具类，用于处理不同平台的特定功能
class PlatformFeatures {
  /// 判断当前平台是否支持鼠标右键
  static bool get supportsRightClick => 
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  
  /// 判断当前平台是否支持文件系统访问
  static bool get supportsFileSystem => 
      !kIsWeb || kIsWeb && (defaultTargetPlatform == TargetPlatform.windows || 
                           defaultTargetPlatform == TargetPlatform.macOS || 
                           defaultTargetPlatform == TargetPlatform.linux);
  
  /// 判断当前平台是否支持触摸操作
  static bool get supportsTouchInput => 
      kIsWeb || Platform.isAndroid || Platform.isIOS;
  
  /// 判断当前平台是否支持键盘快捷键
  static bool get supportsKeyboardShortcuts => 
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
  
  /// 判断当前平台是否为Web平台
  static bool get isWeb => kIsWeb;
  
  /// 判断当前平台是否为Android平台
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  /// 判断当前平台是否为iOS平台
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  
  /// 判断当前平台是否为Windows平台
  static bool get isWindows => !kIsWeb && Platform.isWindows;
  
  /// 判断当前平台是否为macOS平台
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;
  
  /// 判断当前平台是否为Linux平台
  static bool get isLinux => !kIsWeb && Platform.isLinux;
  
  /// 获取当前平台名称
  static String get platformName {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    if (Platform.isFuchsia) return 'Fuchsia';
    return 'Unknown';
  }
  
  /// 判断当前平台是否支持特定功能
  static bool supportsFeature(PlatformFeature feature) {
    switch (feature) {
      case PlatformFeature.rightClick:
        return supportsRightClick;
      case PlatformFeature.fileSystem:
        return supportsFileSystem;
      case PlatformFeature.touchInput:
        return supportsTouchInput;
      case PlatformFeature.keyboardShortcuts:
        return supportsKeyboardShortcuts;
    }
  }
}

/// 平台特定功能枚举
enum PlatformFeature {
  /// 鼠标右键功能
  rightClick,
  
  /// 文件系统访问功能
  fileSystem,
  
  /// 触摸输入功能
  touchInput,
  
  /// 键盘快捷键功能
  keyboardShortcuts,
} 