import 'package:tudo/common/net/http/base_service.dart';
import 'package:tudo/common/net/http/service/bis_service.dart';
import '../base_api.dart';

BisService dmBisService = BisService();

class Api extends BaseApi {
  static final Api ins = Api._();

  Api._();

  @override
  BaseDioProvider getApiProvider() {
    return dmBisService;
  }

  init() {
    getApiProvider().initDio();
  }
}
