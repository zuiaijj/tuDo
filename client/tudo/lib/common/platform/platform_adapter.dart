import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 平台适配器，用于根据不同平台提供相应的UI组件
class PlatformAdapter {
  /// 判断当前是否为移动平台（Android或iOS）
  static bool get isMobile => 
      defaultTargetPlatform == TargetPlatform.android || 
      defaultTargetPlatform == TargetPlatform.iOS;
  
  /// 判断当前是否为桌面平台（Windows、macOS或Linux）
  static bool get isDesktop => 
      defaultTargetPlatform == TargetPlatform.windows || 
      defaultTargetPlatform == TargetPlatform.macOS || 
      defaultTargetPlatform == TargetPlatform.linux;
  
  /// 判断当前是否为iOS或macOS平台
  static bool get isApplePlatform => 
      defaultTargetPlatform == TargetPlatform.iOS || 
      defaultTargetPlatform == TargetPlatform.macOS;
      
  /// 获取平台适配的进度指示器
  static Widget getProgressIndicator() {
    if (isApplePlatform) {
      return const CupertinoActivityIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }
} 