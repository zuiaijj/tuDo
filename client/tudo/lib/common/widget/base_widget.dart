import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tudo/tool/get_tool.dart';

/// 通用按钮组件
/// 支持可点击和不可点击两种状态
/// 支持自定义宽高，提供默认尺寸
/// 支持自定义child内容，当设置child时不展示text
// ignore: non_constant_identifier_names
Widget Btn(
  String text, {
  VoidCallback? onPressed,
  bool enabled = true, // 独立的启用状态控制
  double? width,
  double? height,
  Widget? child, // 自定义子组件，优先于text显示
}) {
  // 默认尺寸基于Figma设计 (331x56)
  final double buttonWidth = width ?? 331.0.w;
  final double buttonHeight = height ?? 56.0.h;

  return SizedBox(
    width: buttonWidth,
    height: buttonHeight,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        // 根据enabled状态设置背景色 - 使用主题颜色
        backgroundColor: enabled
            ? colorScheme.primary // 可点击：使用主题主色
            : colorScheme.surfaceContainerLowest, // 不可点击：使用主题灰色背景
        // 根据enabled状态设置前景色 - 使用主题颜色
        foregroundColor: enabled
            ? colorScheme.onPrimary // 可点击：使用主题主色上的文字颜色
            : colorScheme.onSurfaceVariant, // 不可点击：使用主题变体文字颜色
        // 设置圆角
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // 移除默认的阴影和高度效果
        elevation: 0,
        shadowColor: Colors.transparent,
        // 设置按钮的最小尺寸
        minimumSize: Size(buttonWidth, buttonHeight),
        maximumSize: Size(buttonWidth, buttonHeight),
        // 移除按钮的内边距，让文字居中
        padding: EdgeInsets.zero,
      ),
      // 只有在enabled为true时才执行onPressed
      onPressed: enabled ? onPressed : null,
      // 优先显示child，如果没有child则显示text
      child: child ??
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.21, // lineHeight转换为height
              // 文字颜色会自动使用foregroundColor，这里不需要再设置
            ),
            textAlign: TextAlign.center,
          ),
    ),
  );
}

/// 返回按钮组件
/// 基于Figma设计：41x41px，白色背景，灰色边框，12px圆角
Widget backBtn(VoidCallback onPressed) {
  return Container(
    width: 40.w,
    height: 40.w,
    decoration: BoxDecoration(
      // 使用主题中的背景色，在亮色主题下为白色
      color: colorScheme.surfaceBright, // #FEFEFE in light theme
      // 边框
      border: Border.all(
        color: colorScheme.outlineVariant, // #EAEAEA in light theme
        width: 1,
      ),
      // 圆角
      borderRadius: BorderRadius.circular(12),
    ),
    child: IconButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero, // 移除默认内边距
      splashRadius: 12,
      constraints: BoxConstraints(
        minWidth: 40.w,
        minHeight: 40.w,
        maxWidth: 40.w,
        maxHeight: 40.w,
      ),
      icon: Image.asset(
        'assets/base/back_arrow.png',
        width: 19.w,
        height: 19.w,
        color: colorScheme.primary,
      ),
    ),
  );
}

/// AppBar 左侧控件
Widget appBarBack({Color? arrowColor, GestureTapCallback? onBackAction}) {
  return InkWell(
      onTap: onBackAction ?? () => Get.back(),
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Image.asset(
          'assets/base/back_arrow.png',
          width: 19.w,
          height: 19.w,
          color: colorScheme.primary,
        ),
      ));
}
