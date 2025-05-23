import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo/pages/root/root_page_controller.dart';
import 'package:tudo/pages/root/splash.dart';

/// 页面Root page
/// 所有页面的根页面
/// 本身是Stack结构，用以登陆，广告，首页，等页面切换
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<RootPageController>(
        init: RootPageController(),
        builder: (controller) {
          return Stack(
            children: [
              // 首页大厅
              if (controller.isLoggedIn) Container(),

              // 登录页面
              if (!controller.isLoggedIn) Container(),

              // 加载页面
              if (controller.isLoading) const SplashPage(),
            ],
          );
        },
      ),
    );
  }
}
