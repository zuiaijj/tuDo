import 'package:flutter/material.dart';

/// 响应式布局助手，用于处理不同屏幕尺寸的适配
class ResponsiveHelper {
  /// 移动设备的最大宽度
  static const double mobileMaxWidth = 600;
  
  /// 平板设备的最大宽度
  static const double tabletMaxWidth = 1200;
  
  /// 判断当前设备是否为移动设备
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileMaxWidth;
  }
  
  /// 判断当前设备是否为平板设备
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileMaxWidth && width < tabletMaxWidth;
  }
  
  /// 判断当前设备是否为桌面设备
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= tabletMaxWidth;
  }
  
  /// 获取基于屏幕宽度的响应式值
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context) && desktop != null) {
      return desktop;
    }
    if (isTablet(context) && tablet != null) {
      return tablet;
    }
    return mobile;
  }
  
  /// 获取基于屏幕宽度的响应式布局
  static Widget getResponsiveLayout({
    required BuildContext context,
    required Widget mobileLayout,
    Widget? tabletLayout,
    Widget? desktopLayout,
  }) {
    if (isDesktop(context) && desktopLayout != null) {
      return desktopLayout;
    }
    if (isTablet(context) && tabletLayout != null) {
      return tabletLayout;
    }
    return mobileLayout;
  }
  
  /// 获取基于屏幕宽度的响应式内边距
  static EdgeInsets getResponsivePadding(BuildContext context) {
    return getResponsiveValue<EdgeInsets>(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }
  
  /// 获取基于屏幕宽度的响应式字体大小
  static double getResponsiveFontSize(
    BuildContext context, {
    required double baseFontSize,
    double? tabletFactor = 1.2,
    double? desktopFactor = 1.4,
  }) {
    return getResponsiveValue<double>(
      context: context,
      mobile: baseFontSize,
      tablet: baseFontSize * (tabletFactor ?? 1.2),
      desktop: baseFontSize * (desktopFactor ?? 1.4),
    );
  }
  
  /// 获取基于屏幕宽度的响应式网格列数
  static int getResponsiveGridCount(BuildContext context) {
    return getResponsiveValue<int>(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 4,
    );
  }
} 