import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tudo/common/theme/theme_manager.dart';
import 'package:tudo/tool/get_tool.dart';
import 'package:tudo/tool/system.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true); // 设置循环播放，并反向播放

    _animation = Tween<double>(
      begin: 0.3, // 最小透明度
      end: 1.0, // 最大透明度
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // 使用easeInOut曲线使动画更平滑
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ThemeManager.getThemeLogoTran(context),
        ),
      ),
    );
  }
}
