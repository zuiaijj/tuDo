import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class ToastTool {
  static void configToast() {
    BotToast.defaultOption.text.animationDuration =
        const Duration(milliseconds: 1500);
    BotToast.defaultOption.text.backgroundColor =
        Colors.black.withValues(alpha: 0.7);
  }

  static CancelFunc show(String text) {
    return BotToast.showText(text: text);
  }

  //* 显示加载中
  //* [text] 显示的文字
  //* [clickClose] 是否可以点击关闭
  //* [crossPage] 是否可以跨页面
  //* [allowClick] 是否可以点击loading后的其他页面
  static CancelFunc showLoading(
      {bool clickClose = false,
      bool crossPage = true,
      bool allowClick = false}) {
    return BotToast.showLoading(
      crossPage: crossPage,
      allowClick: allowClick,
      clickClose: clickClose,
    );
  }

  static void closeAllLoading() {
    BotToast.closeAllLoading();
  }
}
