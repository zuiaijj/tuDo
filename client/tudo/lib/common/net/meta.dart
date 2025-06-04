import 'package:tudo/common/log/td_logger.dart';
import 'package:tudo/common/user/user_manager.dart';

class MetaTool {
  /// meta信息
  static final _metaData = <String, dynamic>{};

  /// meta Url param (key=value&key=value)
  static Future<String> getMetaUrl({bool forceFetch = false}) async {
    if (_metaData.isEmpty || !_containUserMeta() || forceFetch) {
      await fetchMetaMap();
    }
    return Uri(
        queryParameters: _metaData
            .map((key, value) => MapEntry(key, value.toString()))).query;
  }

  /// 是否有用户session信息
  static bool _containUserMeta() {
    return _metaData.containsKey('uid') && _metaData.containsKey('sid');
  }

  /// 获取内存中的 _metaData
  static Future<Map<String, dynamic>> getCurrentMetaData() async {
    if (_metaData.isNotEmpty && _containUserMeta()) return _metaData;
    return await fetchMetaMap();
  }

  /// 拉取meta信息
  static Future<Map<String, dynamic>> fetchMetaMap() async {
    Map<String, dynamic> data = <String, dynamic>{};

    data['uid'] = UserManager.instance.user?.id;
    data['access_token'] = UserManager.instance.user?.session;

    _metaData.clear();
    _metaData.addAll(data);
    return data;
  }

  /// 清空meta信息
  static clearMetaData() {
    _metaData.clear();
    TdLogger.i('clear meta data');
  }

  static setMetaLanguage(String language) async {
    if (language.isEmpty) return;
    if (_metaData.isEmpty) await fetchMetaMap();
    _metaData['lca_lang'] = language; // 语言码
  }

  static setMetaCountryCode(String countryCode) async {
    if (countryCode.isEmpty) return;
    if (_metaData.isEmpty) await fetchMetaMap();
    _metaData['country'] = countryCode; // 国家、地区码
  }

  static setMetaSupTdID(String supMetaTdId) async {
    if (supMetaTdId.isEmpty) return;
    if (_metaData.isEmpty) await fetchMetaMap();
    _metaData['suptd_id'] = supMetaTdId;
    _metaData['smid'] = supMetaTdId; // 数盟ID 设置为同盾ID
    _metaData['ndid'] = supMetaTdId; // 设备ID
  }

  static void setMetaTdId(String blackBoxTdId) async {
    if (blackBoxTdId.isEmpty) return;
    if (_metaData.isEmpty) await fetchMetaMap();
    _metaData['tdid'] = blackBoxTdId;
  }

  static setMetaUUID(String uuid) async {
    if (uuid.isEmpty) return;
    if (_metaData.isEmpty) await fetchMetaMap();
    _metaData['nniq'] = uuid;
  }

  static String getNdid() {
    if (_metaData.isEmpty) return '';
    return _metaData['ndid'];
  }

  static String getUUID() {
    if (_metaData.isEmpty) return '';
    return _metaData['nniq'];
  }
}
