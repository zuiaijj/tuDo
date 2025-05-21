import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tudo/common/log/td_logger.dart';
import 'package:tudo/common/net/http/model/base_net_model.dart';
import 'package:tudo/tool/intl_tool.dart';
import 'package:tudo/tool/string_tool.dart';
import 'package:tudo/tool/url_tool.dart';
import 'base_service.dart';
import 'interceptor/dio_http_formatter_base.dart';

enum RequestType { get, post }

Type typeOf<T>() => T;

typedef SuccessCallBack<BaseNetModel> = Function(BaseNetModel? resModel);
typedef ErrorCallBack = dynamic Function(int code, String errorMsg,
    {Map? rawData});

abstract class BaseApi {
  BaseDioProvider getApiProvider();

  /// header
  Map<String, dynamic>? _headMaker(
      BaseDioProvider provider, Map<String, dynamic>? header) {
    Map<String, dynamic>? headerParams = {};
    var globalHeaderParams = provider.serviceHeader();
    if (globalHeaderParams != null) {
      headerParams.addAll(globalHeaderParams);
    }
    if (header != null) headerParams.addAll(header);
    return headerParams;
  }

  /// query
  Future<Map<String, dynamic>?> _queryMaker(
      BaseDioProvider provider, Map<String, dynamic>? param) async {
    Map<String, dynamic>? queryParams = {};
    var globalQueryParams = await provider.serviceQuery();
    if (globalQueryParams != null) queryParams.addAll(globalQueryParams);
    if (param != null) queryParams.addAll(param);
    return queryParams;
  }

  /// body
  Future<Map<String, dynamic>?> _bodyMaker(
      BaseDioProvider provider, Map<String, dynamic>? body) async {
    Map<String, dynamic>? bodyParams = {};
    var globalBodyParams = await provider.serviceBody();
    if (globalBodyParams != null) {
      bodyParams.addAll(globalBodyParams);
    }
    if (body != null) bodyParams.addAll(body);
    return bodyParams;
  }

  Future<BaseNetRes> post(String url,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? header,
      bool forceFetch = false,
      bool isShowLog = true,
      SuccessCallBack<BaseNetRes>? successCallBack,
      ErrorCallBack? errorCallBack}) async {
    if (url.isSafeEmpty) {
      errorCallBack?.call(-1, 'url is Null 💣');
      return BaseNetRes.error('url is Null 💣');
    }

    BaseDioProvider? service = getApiProvider();
    Map<String, dynamic>? headerParams = _headMaker(service, header);
    Map<String, dynamic>? bodyParams = await _bodyMaker(service, body);
    return _request(service, RequestType.post, url, headerParams, null,
        bodyParams, forceFetch, isShowLog, successCallBack, errorCallBack);
  }

  Future<BaseNetRes> get(String url,
      {Map<String, dynamic>? param,
      Map<String, dynamic>? header,
      bool forceFetch = false,
      bool isShowLog = true,
      SuccessCallBack<BaseNetRes>? successCallBack,
      ErrorCallBack? errorCallBack}) async {
    if (url.isSafeEmpty) {
      errorCallBack?.call(-1, 'url is Null 💣');
      return BaseNetRes.error('url is Null 💣');
    }
    BaseDioProvider? service = getApiProvider();
    Map<String, dynamic>? queryParams = await _queryMaker(service, param);
    Map<String, dynamic>? headerParams = _headMaker(service, header);
    return _request(service, RequestType.get, url, headerParams, queryParams,
        null, forceFetch, isShowLog, successCallBack, errorCallBack);
  }

  Future<BaseNetRes> _request(
      BaseDioProvider provider,
      RequestType method,
      String uri,
      Map<String, dynamic>? header,
      Map<String, dynamic>? query,
      Map<String, dynamic>? body,
      bool forceFetch,
      bool isShowLog,
      SuccessCallBack<BaseNetRes>? successCallBack,
      ErrorCallBack? errorCallBack) async {
    final Dio dio = provider.dio;
    if (isShowLog) {
      bool haveInterceptor =
          dio.interceptors.whereType<FormatterInterceptor>().isEmpty;
      if (haveInterceptor) {
        Interceptor interceptor = FormatterInterceptor(httpLoggerFilter: () {
          // return !EnvManager.isOnline;
          return true;
        });
        dio.interceptors.add(interceptor);
      }
    } else {
      dio.interceptors
          .removeWhere((element) => element is FormatterInterceptor);
    }
    final Options options = Options(headers: header);
    String url = await UrlTool.urlWithMeta(provider.baseUrl + uri,
        forceFetch: forceFetch); // 拼接url

    Response? response;
    Completer<BaseNetRes> completer = Completer();
    try {
      switch (method) {
        case RequestType.get:

          /// get
          if (query != null && query.isNotEmpty) {
            response =
                await dio.get(url, queryParameters: query, options: options);
          } else {
            response = await dio.get(url, options: options);
          }
          break;
        case RequestType.post:

          /// post
          if (body != null && body.isNotEmpty) {
            response = await dio.post(url, data: body, options: options);
          } else {
            response = await dio.post(url, options: options);
          }
          break;
      }
    } on DioException catch (error) {
      // 错误回调
      errorCallBack?.call(
          error.response?.statusCode ?? -1, provider.errorFactory(error));
      TdLogger.e(error.message ?? intlS.network_failed);
      _onErrorTip(error);
      completer
          .complete(BaseNetRes.error(error.message ?? intlS.network_failed));
    }

    /// 响应体
    if (response != null && response.data != null) {
      if (response.statusCode == 200) {
        BaseNetRes? result = _httpSuccess(
            response, provider, successCallBack, errorCallBack,
            rawUrl: url);
        completer.complete(result);
      } else {
        _httpError(errorCallBack, response.statusCode ?? -1,
            response.statusMessage ?? intlS.network_failed,
            rawUrl: url);
        completer.complete(
            BaseNetRes.error(response.statusMessage ?? intlS.network_failed));
      }
    }
    return completer.future;
  }

  _onErrorTip(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
        // ToastTool.show(intlS.network_failed);
        break;
      default:
        break;
    }
  }

  _httpError(ErrorCallBack? errorCallBack, int code, String msg,
      {String? rawUrl}) async {
    TdLogger.e('rawUrl: $rawUrl \n code : $code, msg : $msg');
    if (code == 604) {
      // ToastTool.show(msg);
      TdLogger.i("-Login- 退出登录  Net err Code: 604");
      // UserManager.instance.logout();
      return;
    }
    errorCallBack?.call(code, msg);
  }

  BaseNetRes? _httpSuccess(
      Response response,
      BaseDioProvider provider,
      SuccessCallBack<BaseNetRes>? successCallBack,
      ErrorCallBack? errorCallBack,
      {String? rawUrl}) {
    try {
      Map<String, dynamic> dataMap =
          response.data is Map ? response.data : json.decode(response.data);
      dataMap = provider.responseFactory(dataMap);
      BaseNetRes entity = BaseNetRes.fromJson(dataMap);
      if (entity.isSuccess == true) {
        successCallBack?.call(entity);
        return entity;
      } else {
        _httpError(errorCallBack, entity.code, entity.message, rawUrl: rawUrl);
        return entity;
      }
    } catch (e) {
      _httpError(errorCallBack, -1, e.toString(), rawUrl: rawUrl);
      return null;
    }
  }
}
