import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // 使用响应式布局助手获取适合当前屏幕的布局
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tudo'),
      ),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
} 