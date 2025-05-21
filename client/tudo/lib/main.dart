import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/common/app_config/get_pages.dart';
import 'package:tudo/common/const/app_const.dart';
import 'package:tudo/common/platform/platform_adapter.dart';
import 'package:tudo/common/theme_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用平台适配的主题
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true, // 是否根据宽度的最小值适配文字
      splitScreenMode: true, // 支持分屏尺寸
      child: GetMaterialApp(
        title: AppConst.appName,
        theme: ThemeManager.getPlatformTheme(isDark: false),
        darkTheme: ThemeManager.getPlatformTheme(isDark: true),
        popGesture: GetPlatform.isIOS,
        initialRoute: defaultPage,
        getPages: GlobalPages.pages,
        // 根据系统设置自动切换亮暗主题
        themeMode: ThemeMode.system,
        // 根据平台设置不同的滚动行为
        scrollBehavior: PlatformAdapter.isApplePlatform
            ? const CupertinoScrollBehavior()
            : const MaterialScrollBehavior(),
        // 调试标志
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
