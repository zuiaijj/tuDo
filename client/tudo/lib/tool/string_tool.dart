import 'dart:math';
import 'package:get/get.dart';
import 'package:tudo/tool/img_url.dart';

extension StringTool on String? {
  bool get isSafeNotEmpty => this != null && this!.isNotEmpty;
  bool get isSafeEmpty => this == null || this!.isEmpty;
  String get safeValue => this ?? '';
}

bool isEmptyString(String? str) {
  return str == null || str.isEmpty;
}

bool isNotEmptyString(String? str) {
  return str != null && str.isNotEmpty;
}

class DMStringTool {
  static String scaleImageUrl(
    String url, {
    double width = -1,
    double height = -1,
    double maxWidth = 1080,
    double maxHeight = 1920,
    double? rat,
  }) {
    assert(width > 0 || height > 0);

    if (url.isEmpty) {
      return "";
    }

    //减少碎片
    double ratio = rat ?? (Get.pixelRatio < 2.5 ? 1.5 : 2);
    //减少碎片
    if (width > 0) width = toInteger(width, precision: 50);
    if (height > 0) height = toInteger(height, precision: 50);

    return ScaleImgUrl.getScaleImage(
        url,
        min((width * ratio).toInt(), maxWidth.toInt()),
        min((height * ratio).toInt(), maxHeight.toInt()));
  }

  static double toInteger(double num, {int precision = 30}) {
    num = num - (num % precision) + precision;
    return num;
  }
}

extension ListTool<T> on List<T>? {
  bool get isSafeNotEmpty => this != null && this!.isNotEmpty;
  bool get isSafeEmpty => this == null || this!.isEmpty;
}
