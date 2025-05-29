import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tudo/tool/string_tool.dart';

/// 计算工具类
class CalTool {
  static int _singleClickHashCode = 0;
  static DateTime? _singleClickLastClickTime;

  /// 防止重复点击
  static singleClick(Function performClick, int hashCode,
      {int milliseconds = 500}) {
    if (_singleClickHashCode != hashCode) {
      _singleClickHashCode = hashCode;
      performClick();
      _singleClickLastClickTime = DateTime.now();
      return;
    } else {
      if (_singleClickLastClickTime == null ||
          DateTime.now().difference(_singleClickLastClickTime!).inMilliseconds >
              milliseconds) {
        _singleClickLastClickTime = DateTime.now();
        performClick();
        return;
      }
    }
  }

  static Color getColorFromHex(String? hexColor,
      {Color defaut = Colors.white}) {
    if (hexColor.isSafeEmpty) return defaut;
    hexColor = hexColor!.toUpperCase().replaceAll("#", "");
    hexColor = hexColor.replaceAll('0X', '');
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    Color color;
    try {
      color = Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      color = defaut;
    }
    return color;
  }

  static List<Color> hexColors(List<String> coloStrs) {
    List<Color> colors = List.generate(coloStrs.length, (index) {
      return getColorFromHex(coloStrs[index]);
    });
    return colors;
  }

  static double convertToDouble(source) {
    if (source == null || source == "") {
      return 0;
    }
    if (source is double) {
      return source;
    } else if (source is String) {
      return double.parse(source);
    } else if (source is bool) {
      return source == true ? 1 : 0;
    } else {
      return double.parse(source.toString());
    }
  }

  static int convertToInt(source) {
    if (source == null || source == "") {
      return 0;
    }
    if (source is int) {
      return source;
    } else if (source is String) {
      return int.parse(source);
    } else if (source is bool) {
      return source == true ? 1 : 0;
    } else if (source is double) {
      return source.toInt();
    } else {
      return int.parse(source.toString());
    }
  }

  /// 文本高度
  static double calculateTextHeight(
    BuildContext context,
    String value, {
    required double fontSize,
    required FontWeight fontWeight,
    required double maxWidth,
    required int maxLines,
    double textHeight = 1.1,
  }) {
    if (value.isEmpty) return 0.0;
    TextPainter painter = _calculateTextPainter(context, value,
        fontSize: fontSize,
        fontWeight: fontWeight,
        maxWidth: maxWidth,
        textHeight: textHeight,
        maxLines: maxLines);
    return painter.height;
  }

  /// 文本宽度
  static double calculateTextWidthInStyle(BuildContext context, String value,
      {required TextStyle style,
      required double maxWidth,
      required int maxLines}) {
    if (value.isEmpty) return 0.0;
    TextPainter painter = _calculateTextPainterInStyle(context, value,
        style: style, maxWidth: maxWidth, maxLines: maxLines);
    return painter.width;
  }

  /// 文本宽度
  static double calculateTextWidth(BuildContext context, String value,
      {required double fontSize,
      required FontWeight fontWeight,
      required double maxWidth,
      required int maxLines}) {
    if (value.isEmpty) return 0.0;
    TextPainter painter = _calculateTextPainter(context, value,
        fontSize: fontSize,
        fontWeight: fontWeight,
        maxWidth: maxWidth,
        maxLines: maxLines);
    return painter.width;
  }

  static _calculateTextPainter(BuildContext context, String value,
      {required double fontSize,
      required FontWeight fontWeight,
      required double maxWidth,
      double textHeight = 1.1,
      required int maxLines}) {
    TextPainter painter = TextPainter(
      locale: Localizations.maybeLocaleOf(context),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: value,
        style: TextStyle(
            fontWeight: fontWeight, fontSize: fontSize, height: textHeight),
      ),
    );
    painter.layout(maxWidth: maxWidth);
    return painter;
  }

  static _calculateTextPainterInStyle(BuildContext context, String value,
      {required TextStyle style,
      required double maxWidth,
      required int maxLines}) {
    TextPainter painter = TextPainter(
      locale: Localizations.maybeLocaleOf(context),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: value,
        style: style,
      ),
    );
    painter.layout(maxWidth: maxWidth);
    return painter;
  }

  /// 文本宽度
  static double measureTextWidth(BuildContext context, String value,
      {required double fontSize,
      FontWeight? fontWeight,
      double? maxWidth,
      int? maxLines}) {
    return calculateTextWidth(context, value,
        fontSize: fontSize,
        fontWeight: fontWeight ?? FontWeight.normal,
        maxWidth: maxWidth ?? 100,
        maxLines: maxLines ?? 1);
  }
}

isNotEmptryList(List? value) {
  return value != null && value.isSafeNotEmpty;
}

isEmptyList(List? value) {
  return value == null || value.isEmpty;
}

isNotEmptyMap(Map? value) {
  return value != null && value.isNotEmpty;
}

isEmptyMap(Map? value) {
  return value == null || value.isEmpty;
}

isNotEmptryInt(int? value) {
  return value != null && value != 0;
}

isEmptyInt(int? value) {
  return value == null || value == 0;
}

T defaultVlaue<T>(T? value, T defaultValue) {
  if (value == null) {
    return defaultValue;
  }
  if (value is String) {
    return isEmptyString(value) ? defaultValue : value;
  }
  if (value is List) {
    return isEmptyList(value) ? defaultValue : value;
  }
  if (value is Map) {
    return isEmptyMap(value) ? defaultValue : value;
  }
  if (value is int) {
    return isEmptyInt(value) ? defaultValue : value;
  }
  return defaultValue;
}

extension SafeCompleter<T> on Completer<T> {
  safeComplete([FutureOr<T>? value]) {
    if (!isCompleted) {
      complete(value);
    }
  }
}

extension WeakExtension<T> on Object {
  WeakReference<Object> get weakF => WeakReference<Object>(this);
  T? get weak => WeakReference(this).target as T?;
}
