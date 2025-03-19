import 'package:flutter/material.dart';
import 'package:tudo/common/theme_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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
      end: 1.0,   // 最大透明度
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
      backgroundColor: colorScheme(context).surface,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ThemeManager.getThemeLogo(context),
        ),
      ),
    );
  }
} 