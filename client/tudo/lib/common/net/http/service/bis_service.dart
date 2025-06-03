import 'dart:io';
import 'package:dio/io.dart';
import 'package:tudo/common/const/app_const.dart';
import 'package:tudo/common/env/env_manager.dart';
import 'package:tudo/tool/sp_tool.dart';
import 'package:tudo/tool/string_tool.dart';
import '../base_service.dart';

const String dmProxyIP = "dmProxyIP";

/// 业务服务
class BisService extends BaseDioProvider {
  BisService();

  @override
  Map<String, dynamic>? serviceHeader() {
    Map<String, dynamic> header = <String, dynamic>{};
    return header;
  }

  /// 公共的query
  @override
  Future<Map<String, dynamic>?> serviceQuery() async {
    return {};
  }

  /// 公共的body
  @override
  Future<Map<String, dynamic>?> serviceBody() async {
    return {};
  }

  /// 初始化Dio
  @override
  void initDio() {
    super.initDio();
    baseUrl = EnvManager.isTest
        ? AppServerConfig.testServiceApi
        : AppServerConfig.serviceApi;
    if (EnvManager.isLocal) {
      baseUrl = 'http://127.0.0.1:8000';
    }
    dio.options.headers = {
      "Access-Control-Allow-Origin": "*",
    };
    dio.options.connectTimeout = const Duration(milliseconds: 10000);
    dio.options.receiveTimeout = const Duration(milliseconds: 8000);
    dio.options.contentType = "application/json";
    // String proxyIp = SpTool.getString(dmProxyIP);
    String proxyIp = "192.168.15.133";
    if (proxyIp.isSafeNotEmpty) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        HttpClient client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true;
        };
        client.findProxy = (uri) {
          return "PROXY $proxyIp:8888";
        };
        return client;
      };
    }
  }

  @override
  Map<String, dynamic> responseFactory(Map<String, dynamic> dataMap) {
    return dataMap;
  }
}
