import 'package:tudo/common/const/app_const.dart';

class ScaleImgUrl {
  static const int QUALITY_DEFAULT = 80;

  static String? IMAGE_SCALE;

  //宽度自动缩放
  static String getScaleImageWithHeight(String url, int height) {
    return scaleImage(url, -1, height, QUALITY_DEFAULT);
  }

  //高度自动缩放
  static String getScaleImageWithWidth(String url, int width) {
    return scaleImage(url, width, -1, QUALITY_DEFAULT);
  }

  static String getScaleImage(String url, int width, int height) {
    return scaleImage(url, width, height, QUALITY_DEFAULT);
  }

  static String scaleMiddleImage(
    String url,
    int width,
    int height, {
    int quality = QUALITY_DEFAULT,
    int origin = 0,
  }) {
    return scaleImage(url, width, height, quality, origin: origin) + "&m=1";
  }

  static String scaleRadiusImage(
    String url,
    int width,
    int height, {
    int quality = 100,
    int origin = 0,
    int iradius = 100,
  }) {
    return scaleImage(url, width, height, quality, origin: origin) +
        "&iradius=$iradius";
  }

  static String getTypeStr(String url) {
    if (url.isEmpty) return "";
    var list = url.split(".");
    if (list.last.isNotEmpty) return list.last.toLowerCase();
    return "";
  }

  static int getOrigin(String url, int origin) {
    if (url.isEmpty) return 0;
    String tmp = url.toLowerCase();
    if (tmp.endsWith(".webp") || tmp.endsWith(".gif")) return 1;
    return origin;
  }

  static String scaleImage(
    String url,
    int width,
    int height,
    int quality, {
    int origin = 0,
  }) {
    if (url.isEmpty) return url;

    url = Uri.encodeComponent(url);

    int originfinal = getOrigin(url, origin);

    String? baseUrl = IMAGE_SCALE;
    if (baseUrl == null || baseUrl.isEmpty || baseUrl == "") {
      baseUrl = AppServerConfig.ONLINE_SCALE_IMG_URL;
    }

    StringBuffer sb = StringBuffer(baseUrl);
    sb..write(url);
    if (width > 0) {
      sb
        ..write("&w=")
        ..write(width.toString());
    }
    if (height > 0) {
      sb
        ..write("&h=")
        ..write(height.toString());
    }
    sb
      ..write("&s=")
      ..write(quality.toString())
      ..write("&c=0&o=")
      ..write(originfinal.toString())
      ..write("&t=0");

    return sb.toString();
  }
}
