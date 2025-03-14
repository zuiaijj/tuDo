import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tudo/common/theme_manager.dart';

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
  
  /// 获取平台适配的应用栏
  static Widget getAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
    Color? backgroundColor,
  }) {
    if (isApplePlatform) {
      return CupertinoNavigationBar(
        middle: Text(title),
        backgroundColor: backgroundColor,
        leading: leading,
        trailing: actions != null && actions.isNotEmpty 
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: actions,
              ) 
            : null,
      );
    } else {
      return AppBar(
        title: Text(title),
        backgroundColor: backgroundColor,
        actions: actions,
        leading: leading,
      );
    }
  }
  
  /// 获取平台适配的按钮
  static Widget getButton({
    required Widget child,
    required VoidCallback onPressed,
    Color? color,
  }) {
    if (isApplePlatform) {
      return CupertinoButton(
        onPressed: onPressed,
        color: color,
        child: child,
      );
    } else {
      return ElevatedButton(
        onPressed: onPressed,
        style: color != null ? ElevatedButton.styleFrom(backgroundColor: color) : null,
        child: child,
      );
    }
  }
  
  /// 获取平台适配的文本输入框
  static Widget getTextField({
    required String placeholder,
    TextEditingController? controller,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    if (isApplePlatform) {
      return CupertinoTextField(
        placeholder: placeholder,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    } else {
      return TextField(
        decoration: InputDecoration(
          hintText: placeholder,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
      );
    }
  }
  
  /// 获取平台适配的页面脚手架
  static Widget getScaffold({
    required Widget body,
    Widget? appBar,
    Widget? bottomNavigationBar,
    Widget? floatingActionButton,
    Color? backgroundColor,
  }) {
    if (isApplePlatform) {
      return CupertinoPageScaffold(
        navigationBar: appBar as CupertinoNavigationBar?,
        backgroundColor: backgroundColor,
        child: body,
      );
    } else {
      return Scaffold(
        appBar: appBar as PreferredSizeWidget?,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        backgroundColor: backgroundColor,
      );
    }
  }
  
  /// 获取平台适配的标签栏
  static Widget getTabBar({
    required List<Widget> tabs,
    required List<Widget> tabViews,
  }) {
    if (isApplePlatform) {
      return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: tabs.map((tab) {
            if (tab is Icon) {
              return BottomNavigationBarItem(
                icon: tab,
                label: '',
              );
            } else if (tab is Text) {
              return BottomNavigationBarItem(
                icon: const Icon(CupertinoIcons.circle),
                label: (tab).data,
              );
            }
            return const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.circle),
              label: '',
            );
          }).toList(),
        ),
        tabBuilder: (context, index) {
          return tabViews[index];
        },
      );
    } else {
      return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: tabViews,
          ),
        ),
      );
    }
  }
  
  /// 获取平台适配的对话框
  static Future<T?> showAlertDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) {
    if (isApplePlatform) {
      return showCupertinoDialog<T>(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) onCancel();
                },
                isDestructiveAction: true,
                child: Text(cancelText),
              ),
            if (confirmText != null)
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) onConfirm();
                },
                child: Text(confirmText),
              ),
          ],
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            if (cancelText != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onCancel != null) onCancel();
                },
                child: Text(cancelText),
              ),
            if (confirmText != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onConfirm != null) onConfirm();
                },
                child: Text(confirmText),
              ),
          ],
        ),
      );
    }
  }
  
  /// 获取平台适配的进度指示器
  static Widget getProgressIndicator() {
    if (isApplePlatform) {
      return const CupertinoActivityIndicator();
    } else {
      return const CircularProgressIndicator();
    }
  }
} 