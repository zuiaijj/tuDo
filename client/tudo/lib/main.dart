import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/common/route/get_pages.dart';
import 'package:tudo/common/const/app_const.dart';
import 'package:tudo/common/const/root_const.dart';
import 'package:tudo/common/platform/platform_adapter.dart';
import 'package:tudo/common/theme/theme_manager.dart';
import 'package:tudo/generated/l10n.dart';
import 'package:tudo/tool/system.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // 移除固定的状态栏样式设置，改为在应用中动态设置
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // 当系统亮度变化时更新状态栏样式
    _updateStatusBarStyle();
  }

  void _updateStatusBarStyle() {
    final currentTheme = Theme.of(context);
    final isDarkMode = currentTheme.brightness == Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
        SystemInfo.getStatusBarStyle(isDark: isDarkMode));
  }

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
        initialRoute: RouteConst.root,
        getPages: GlobalPages.pages,
        // 根据系统设置自动切换亮暗主题
        themeMode: ThemeMode.system,
        // 根据平台设置不同的滚动行为
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        scrollBehavior: PlatformAdapter.isApplePlatform
            ? const CupertinoScrollBehavior()
            : const MaterialScrollBehavior(),
        // 调试标志
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return BotToastInit()(context, child);
        },
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
