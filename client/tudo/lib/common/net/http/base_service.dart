import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tudo/tool/intl_tool.dart';

abstract class BaseDioProvider {
  late Dio dio;

  late var _baseUrl = "";

  BaseDioProvider();

  set baseUrl(value) {
    if (_baseUrl == value) return;
    _baseUrl = value;
    dio.options.baseUrl = _baseUrl;
  }

  get baseUrl => _baseUrl;

  @mustCallSuper
  initDio() {
    dio = Dio();
  }

  /// 公共的header
  Map<String, dynamic>? serviceHeader();

  /// 公共的query
  Future<Map<String, dynamic>?> serviceQuery();

  /// 公共的body
  Future<Map<String, dynamic>?> serviceBody();

  /// 公共响应解析
  Map<String, dynamic> responseFactory(Map<String, dynamic> dataMap);

  String errorFactory(DioException error) {
    String errorMessage = error.message ?? '';
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timeout";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receive timeout";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Send timeout";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Bad certificate";
        break;
      case DioExceptionType.badResponse:
        try {
          int? errCode = error.response?.statusCode;
          errorMessage = "$errCode: ${intlS.network_failed}";
        } on Exception catch (_) {
          errorMessage = error.message ?? intlS.network_failed;
        }
        break;
      case DioExceptionType.unknown:
        errorMessage = error.message ?? intlS.network_failed;
        break;
      default:
        errorMessage = error.message ?? intlS.network_failed;
    }
    return errorMessage;
  }
}
