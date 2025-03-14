import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tudo/common/platform_adapter.dart';
import 'package:tudo/common/theme_manager.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用平台适配的主题
    return MaterialApp(
      title: '跨平台应用示例',
      theme: ThemeManager.getPlatformTheme(isDark: false),
      darkTheme: ThemeManager.getPlatformTheme(isDark: true),
      // 根据系统设置自动切换亮暗主题
      themeMode: ThemeMode.system,
      // 使用我们的HomePage作为首页
      home: const HomePage(),
      // 根据平台设置不同的滚动行为
      scrollBehavior: PlatformAdapter.isApplePlatform
          ? const CupertinoScrollBehavior()
          : const MaterialScrollBehavior(),
      // 调试标志
      debugShowCheckedModeBanner: false,
    );
  }
}
