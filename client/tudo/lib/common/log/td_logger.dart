import 'package:logger/logger.dart';

var _logger = Logger(
  printer: PrettyPrinter(),
);

class TdLogger {
  static void d(String message, {String tag = ''}) {
    _logger.d("[$tag] $message");
  }

  static void i(String message, {String tag = ''}) {
    _logger.i("[$tag] $message");
  }

  static void w(String message, {String tag = ''}) {
    _logger.w("[$tag] $message");
  }

  static void e(String message, {String tag = ''}) {
    _logger.e("[$tag] $message");
  }

  static void v(String message, {String tag = ''}) {
    _logger.v("[$tag] $message");
  }

  static void wtf(String message, {String tag = ''}) {
    _logger.wtf("[$tag] $message");
  }
}
