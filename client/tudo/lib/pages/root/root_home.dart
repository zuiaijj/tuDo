import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tudo/common/user/user_manager.dart';
import 'package:tudo/pages/root/root_page_controller.dart';
import 'package:tudo/tool/get_tool.dart';

class RootHome extends StatefulWidget {
  const RootHome({super.key});

  @override
  State<RootHome> createState() => _RootHomeState();
}

class _RootHomeState extends State<RootHome> {
  @override
  void initState() {
    super.initState();
    Get.find<RootPageController>().initEnterHall();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        '登录成功 ${UserManager.instance.user?.id}，欢迎回来',
        style: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
